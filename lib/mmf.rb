require "mmf/version"
require 'oauth2'
require 'json'

class Mmf::Client
  ROOT_URI      = "https://oauth2-api.mapmyapi.com/"

  VAR     = /%\{(.*?)\}/
  API_MAP = {
    # user resources
    me:           { method: :get,  endpoint: 'v7.0/user/self' },
    workouts:     { method: :get,  endpoint: 'v7.0/workout' },
    add_workout:  { method: :post, endpoint: 'v7.0/workout' },
    deactivate:   { method: :post, endpoint: 'v7.0/user_deactivation', },

    user:         { method: :get,  endpoint: 'v7.0/user/%{user_id}' },
    user_create:  { method: :post, endpoint: 'v7.0/user' },
    user_update:  { method: :put,  endpoint: 'v7.0/user/%{user_id}' },
    user_photo:   { method: :get,  endpoint: 'v7.0/user_profile_photo/%{user_id}' },
    user_stats:   { method: :get,  endpoint: 'v7.0/user_stats/%{user_id}' },

    workout:      { method: :get,  endpoint: 'v7.0/workout/%{workout_id}' },

    achievement:  { method: :get,  endpoint: 'v7.0/acievement/%{achievement_id}' },
    achievements: { method: :get,  endpoint: 'v7.0/user_acievement' }
  }

  attr_accessor :client_key, :client_secret, :access_token

  def initialize
    @client_key, @client_secret, @access_token = ""
    yield self
    client  = OAuth2::Client.new(client_key, client_secret)
    @client = OAuth2::AccessToken.new(client, access_token)
  end

  API_MAP.keys.each do |name|
    define_method(name) do |params = {}|
      call(name, params)
    end
  end

  def api
    API_MAP.any? do |name, details|
      vars = details[:endpoint].scan(VAR).flatten
      context = Hash[vars.zip vars.map {|v| ":#{v}"}]
      endpoint = interpolate(details[:endpoint], context)
      puts "client.#{name}".ljust(20) + "=> [#{details[:method]}]".ljust(10) + "#{endpoint}/?params"
    end
  end

private

  def call(name, params)
    method = API_MAP[name][:method]
    endpoint = interpolate(API_MAP[name][:endpoint], params)
    request(method, endpoint, params)
  end

  def request(method, endpoint, params)
    uri  = "#{ROOT_URI}/#{endpoint}"
    opts = { params: params, headers: {'Api-Key' => client_key} }
    resp = @client.send(method, uri, opts)
    JSON.parse(resp.body)
  end

  def interpolate(str, context)
    vars = str.scan(VAR).flatten
    vars.inject(str) do |str, var|
      str.gsub("\%{#{var}}", (context[var.to_sym] || context[var.to_s]).to_s)
    end
  end

end
