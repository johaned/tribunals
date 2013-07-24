source 'https://rubygems.org'
gem 'nokogiri'

gem 'rails', '4.0.0'

gem 'pg'
gem 'carrierwave', :git => 'https://github.com/carrierwaveuploader/carrierwave.git', :branch => 'master'
gem 'will_paginate', '~> 3.0'
gem 'bootstrap-will_paginate'

# For speeding up Postgres array parsing
gem 'pg_array_parser', :git => 'https://github.com/jasiek/pg_array_parser.git', :branch => 'master'

#For importing
gem 'capybara'
gem 'capybara-webkit'

group :test, :development do
  gem 'rspec-rails'
  gem 'warden-rspec-rails'
  
  # workaround for a particular setup - potentially unnecessary
  gem 'debugger-ruby_core_source'

  gem 'debugger'
  gem 'database_cleaner'
end

group :assets do
	gem 'sass-rails'
end

gem 'unicorn'
gem 'fog'
gem 'rails_warden'
gem 'bcrypt-ruby', :require => 'bcrypt'
gem 'whenever', :require => false
gem 'newrelic_rpm'
gem 'haml-rails'
gem 'html2haml'
