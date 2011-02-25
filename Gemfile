source :gemcutter
source 'http://gems.github.com'
gem "rails", "2.3.8"

gem "cancan"
gem 'warden'
gem 'devise', '1.0.9'
gem 'will_paginate', '~> 2.3.8', :git => 'git://github.com/mislav/will_paginate.git'
gem 'gravtastic'
gem 'nokogiri'
gem 'rich-acts_as_revisable'
gem 'acts-as-taggable-on', '~> 2.0.0.rc1'

group :development do
  # bundler requires these gems in development
  # gem "rails-footnotes"
end

group :test do
  gem 'sqlite3-ruby'
  gem 'rspec', '1.3.1'
  gem 'rspec-rails', '1.3.3'
end

group :cucumber do
  gem 'sqlite3-ruby'
  gem 'cucumber-rails', '>=0.3.2'
  gem 'database_cleaner', '>=0.5.0'
  gem 'webrat', '>=0.7.0'
  gem 'rspec', '1.3.1'
  gem 'rspec-rails', '1.3.3'
  gem 'ruby-debug'
  gem 'launchy'
end
