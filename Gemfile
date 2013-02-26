source 'https://rubygems.org'

unless ENV['TRAVIS']
  ruby '1.9.3'
end

gem 'rails', '3.2.12'

gem 'pg'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

gem 'haml-rails', '~> 0.3.5'

group :development do
  gem 'pry', '~> 0.9.11'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.12.2'
end

group :test do
  gem 'rb-inotify', '~> 0.8.8'
  gem 'guard-rspec', '~> 2.4.0'
  gem 'guard-spork', '~> 1.4.1'
  gem 'factory_girl_rails', '~> 4.2.0'
  gem 'shoulda-matchers', '~> 1.4.2'
  gem 'forgery', '~> 0.5.0'
  gem 'capybara', '~> 2.0.2'
  gem 'database_cleaner', '~> 0.9.1'
  gem 'launchy', '~> 2.1.2'

  if ENV['TRAVIS']
    if ENV['DB'] == 'mysql'
      gem 'mysql2', platform: :ruby
    end
    if ENV['DB'] == 'sqlite'
      gem 'sqlite3', platform: :ruby
    end
  end
end

# Auth
gem 'sorcery', '~> 0.8.1'
