source 'https://rubygems.org'

gem 'rails',        '4.2.2'
gem 'bcrypt'
# by hashing the password with bcrypt, we ensure the attacker will not be able to log in
# even if they obtain a copy of the database.
gem 'bootstrap-sass'
gem 'faker'
gem 'will_paginate'
gem 'bootstrap-will_paginate'
gem 'sass-rails',   '5.0.2'
gem 'carrierwave'            # interface for ImageMagick
gem 'mini_magick'            # used to resize image
gem 'fog',          '1.36.0' # used to configure cloud storage in production
gem 'uglifier',     '2.5.3'
gem 'coffee-rails', '4.1.0'
gem 'jquery-rails', '4.0.3'
gem 'turbolinks',   '2.3.0'
gem 'jbuilder',     '2.2.3'
gem 'sdoc',         '0.4.0', group: :doc

group :development, :test do
  gem 'sqlite3',     '1.3.9'
  gem 'byebug',      '3.4.0'
  gem 'web-console', '2.0.0.beta3'
  gem 'spring',      '1.1.3'
end

group :test do
  gem 'minitest-reporters', '1.0.5'
  gem 'mini_backtrace',     '0.1.3'
  gem 'guard-minitest',     '2.3.1'
end

group :production do
  gem 'pg',             '0.17.1'
  gem 'rails_12factor', '0.0.2'
  gem 'puma'
end
