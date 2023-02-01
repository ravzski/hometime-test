source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.1"


gem 'rails', '~> 7.0', '>= 7.0.1'
gem 'puma', '~> 4.1'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'rack-cors'
gem 'dotenv-rails'
gem 'pg'
gem 'bcrypt'
gem 'guard-rspec'
gem 'damerau-levenshtein'

group :development, :test do
  gem 'pry-rails'
  gem 'guard-rspec'
  gem 'rspec-rails', '~> 6.0.0.rc1'
end

group :test do
  gem 'database_cleaner'
  gem 'fuubar'
  gem 'simplecov'
end