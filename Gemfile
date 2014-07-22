source 'https://rubygems.org'

ruby '2.1.2'

gem 'rails', '4.1.4'
gem 'bootstrap-sass', '~> 3.2.0'
gem 'devise'
gem 'rolify'
gem 'cancan'
gem 'bootstrap-datepicker-rails'
gem 'ice_cube'
gem 'protected_attributes'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :production do
  gem 'pg'
  gem 'rails_12factor', '0.0.2'
end


group :development, :test do
  gem 'sqlite3' 
  gem 'rspec-rails', '3.0.1'
end

group :test do
  gem 'capybara', ' ~> 2.4.1'
  gem 'cucumber-rails', :require => false
  gem "factory_girl"
  gem "factory_girl_rails", "~> 4.4.1"
  gem "database_cleaner"
  gem "email_spec"
  gem 'faker', '~> 1.4.2'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 4.0.3'
  gem 'coffee-rails', '~> 4.0.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '~> 2.5.1'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
