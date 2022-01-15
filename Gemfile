# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.0"

gem "bootsnap", ">= 1.4.2", require: false
gem "jbuilder", "~> 2.10.1"
gem "pg", "~> 1.1"
gem "puma", "~> 4.3"
gem "rails", "~> 6.0.3", ">= 6.0.3.4"
gem "rubocop-rails_config", "~> 1.3.3"
gem "bcrypt"
gem "jwt"
gem "sidekiq"

group :development, :test do
  gem "byebug", "~> 11.1.3"
  gem "factory_bot_rails", "~> 6.1.0"
  gem "faker", "~> 2.14.0"
  gem "rspec-rails", "~> 4.0.1"
end

group :development do
  gem "listen", "~> 3.2"
  gem "spring", "~> 2.1.1"
  gem "spring-watcher-listen", "~> 2.0.0"
end
