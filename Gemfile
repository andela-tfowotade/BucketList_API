source "https://rubygems.org"
gem "rails", "4.2.6"
gem "rails-api"
gem "devise"
gem "jwt"
gem "active_model_serializers"
gem "coveralls", require: false

group :development, :test do
  gem "pry-rails"
  gem "simplecov", require: false
  gem "factory_girl_rails"
  gem "sqlite3"
  gem "rubocop", require: false
end

group :development do
  gem "sqlite3"
  gem "spring"
end

group :test do
  gem "rspec-rails", "~> 3.4"
  gem "faker"
  gem "shoulda-matchers", "~> 3.1"
  gem "database_cleaner"
end

group :production do
  gem "pg"
  gem "rails_12factor"
end
