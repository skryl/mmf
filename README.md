# Mmf

A Ruby REST Client for the MapMyFitness API. [Here](http://skryl.org) is how I use it.

## Installation

Add this line to your application's Gemfile:

    gem 'mmf'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mmf

## Authentication Tokens

Mmf uses Oauth2 to authenticate with the MapMyFitness API. Please go [here](https://developer.mapmyapi.com)
to create a developer account and get your client keys. Then go [here](https://developer.mapmyapi.com/io-docs)
to generate an access token.

## Usage

You can provide your credentials during initialization.

```ruby
client = Mmf::Client.new do |config|
  config.client_key    = 'YOUR_CLIENT_KEY'
  config.client_secret = 'YOUR_CLIENT_SECRET'
  config.access_token  = 'YOUR_ACCESS_TOKEN'
end
```

To see which API calls are supported, run the following from irb.

```ruby
client.api
```

The output will show a mapping between method calls and API calls. See the [API docs](https://developer.mapmyapi.com/docs)
for details on each API call or use the MapMyFitness [I/O docs](https://developer.mapmyapi.com/io-docs) to play with the API
from your browser.

```text
client.me           => [get]  v7.0/user/self/?params
client.workouts     => [get]  v7.0/workout/?params
client.add_workout  => [post] v7.0/workout/?params
client.deactivate   => [post] v7.0/user_deactivation/?params
client.user         => [get]  v7.0/user/:user_id/?params
client.user_create  => [post] v7.0/user/?params
client.user_update  => [put]  v7.0/user/:user_id/?params
client.user_photo   => [get]  v7.0/user_profile_photo/:user_id/?params
client.user_stats   => [get]  v7.0/user_stats/:user_id/?params
client.workout      => [get]  v7.0/workout/:workout_id/?params
client.achievement  => [get]  v7.0/acievement/:achievement_id/?params
client.achievements => [get]  v7.0/user_acievement/?params
```

All client methods take an optional params hash which is used to build the
RESTful API endpoint URI.

## Examples

Get all workouts for the authenticated user.

```ruby
client.workouts(user: client.me['id'])
```

Get a single workout with time-series data (distance/heartrate/speed) included.

```ruby
client.workout(workout_id: 456955773, field_set: 'time_series')
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
