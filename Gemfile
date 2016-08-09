source "https://rubygems.org"

gem "rails", "4.2.6"

gem "rails-api"

gem "devise"

gem "jwt"

gem "rspec-rails", "~> 3.4"

gem "faker"

gem "rubocop", "~> 0.40.0", require: false

gem "active_model_serializers"

group :development, :test do
  gem "pry-rails"

  gem "coveralls", require: false

  gem "simplecov", require: false

  gem "factory_girl_rails"

  gem 'shoulda-matchers', '~> 3.1'
end

group :development do
  gem "sqlite3"
  gem "spring"
end

group :test do
  gem "database_cleaner"
end

group :production do
  gem "pg"
  gem "rails_12factor"
end