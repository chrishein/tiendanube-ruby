# TiendaNube

Simple gem to provida a basic connection with the [TiendaNube API](https://github.com/tiendanube/api-docs) endpoints.

This gem is a fork of MIT licensed version created originaly by Diego de Estrada and Nicolás Bares.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tiendanube-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tiendanube-ruby

## Usage

Authorize TiendaNube user and get Access Token:

```ruby
TiendaNube::Auth.config do |config|
    config.client_id = 333
    config.client_secret = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
end

tiendanube_auth = TiendaNube::Auth.new
tiendanube_auth.authorize_url # => 'https://www.tiendanube.com/apps/333/authorize'
```

Once the user has visitd the URL and authorized access, he is redirected to the redirect URL that the app owner
defines when creating it, with the authorization code as a request parameter. Eg.:

```
http://localhost:3000/tn_auth?code=7777777777778888888888889999999999999999
```
Then, you can use that temporary authorization code to get a permanent access token.

```ruby
tiendanube_auth.get_access_token('7777777777778888888888889999999999999999')
# => {:store_id=>88888, :access_token=>"abcd123abcd123abcd123abcd123abcd123abcd123", :scope=>"read_products,write_products,read_customers,read_orders"}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/tienda_nube. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

