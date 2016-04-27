source 'https://rubygems.org'
ruby "2.2.0"

gem 'rails', '4.2.1'
gem "dotenv-rails"
gem "dotenv-deployment"
gem 'appsignal'

# added for rails 4.
gem 'activerecord-session_store'
gem 'protected_attributes'

gem 'sqlite3'
gem 'savon', '~> 2.3.0'
gem 'ultraviolet'
gem 'mysql'
gem 'yaml_db'
gem 'blacklight', '5.9'
gem 'blacklight_range_limit'
gem 'blacklight_cornell_advanced_search', :git => 'git@github.com:cul-it/blacklight-cornell-advanced-search.git', :branch => 'bl5'
gem 'blacklight_unapi', :git => 'git@github.com:cul-it/blacklight-unapi', :branch => 'rails4'
gem 'kaminari', '0.15.0'

gem 'blacklight_google_analytics'
gem 'blacklight-hierarchy'
gem 'json'
gem 'httpclient'
gem 'haml'
gem 'haml-rails'
gem 'marc'
gem 'blacklight-marc'
gem 'rb-readline', '~> 0.4.2'
gem 'net-ldap'
#gem 'newrelic_rpm'
gem 'nokogiri'
gem 'rufus-scheduler'
gem 'addressable'

# Gems used only for assets and not required
# in production environments by default.
  gem 'sass-rails',   '~> 4.0'
  gem 'coffee-rails', '~> 4.0'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  #  gem 'therubyracer', '~> 0.10.2', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'

group :development, :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'cucumber-rails', :require => false # Set require = false to get rid of a warning message
  gem 'database_cleaner'
  gem 'webrat'
  gem 'guard-rspec'
  gem 'poltergeist'
end
  
group :test do
  gem 'capybara'
  # Following two gems are following the setup proposed in the RoR tutorial
  # at http://ruby.railstutorial.org/chapters/static-pages#sec-advanced_setup
  gem 'rb-inotify'
  gem 'libnotify'
  # Spork support
  gem 'guard-spork', '0.3.2'
  gem 'spork', '0.9.0'
  gem 'webmock'
  gem 'vcr'
  gem 'capybara-email'
end

gem 'jquery-rails'
gem 'jquery-ui-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
 gem 'capistrano'
 gem 'capistrano-ext'
 gem 'rvm-capistrano'

# To use debugger
# gem 'debugger'
gem 'unicode', :platforms => [:mri_18, :mri_19, :mri_20]
gem 'devise'
gem 'devise-guests', '~> 0.3'
gem 'bootstrap-sass', '3.3.4.1'
gem 'font-awesome-rails' 
gem 'blacklight_cornell_requests',:git =>'git@github.com:cul-it/blacklight-cornell-requests.git', :branch => 'master'

gem 'bento_search'
gem 'celluloid'  # Required for bento_search multisearcher
# gem 'worldcat'
#gem 'rest_mollom', :git => 'https://github.com/hernan/rest_mollom.git'
gem 'mollom'
#gem 'blacklight-marc'


gem 'rdf', '~> 1.99'
gem 'active-triples', :github => 'ActiveTriples/ActiveTriples', :branch => 'fix206_exclude_othersubj_preds'
gem 'active_triples-local_name'
gem 'active_triples-solrizer', '= 0.3.0'

gem 'ld4l_virtual_collection', '= 0.1.0'
gem 'ld4l-works_rdf', '= 0.1.0'
gem 'ld4l-foaf_rdf', '= 0.1.0'
gem 'ld4l-open_annotation_rdf', '= 0.1.0'
gem 'doubly_linked_list', '~> 0.0'
gem 'ld4l-ore_rdf', '= 0.2.0'

gem 'httparty'

group :development do
  gem 'pry'
  gem 'pry-byebug'
end

gem 'rdf-blazegraph'
