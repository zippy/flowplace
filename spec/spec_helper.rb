# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
require 'spec/rails'

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  def create_user(user='user')
    u = User.new({:user_name => user, :first_name => 'Joe',:last_name => user.capitalize,:email=>"#{user}@#{user}.org"})
    u.create_bolt_identity(:user_name => :user_name,:password => 'password') && u.save!
    u
  end
  
  def create_currency(currency,opts={})
    opts[:steward_id] = 1 unless opts.has_key?(:steward_id)
    if opts.has_key?(:klass)
      klass = opts[:klass]
      opts.delete(:klass)
    else
      klass = Currency
    end
    opts.update({:name => currency})
    c = klass.create!(opts)
    c.save.should == true
    c
  end
  
  def create_currency_account(user,currency,player_class = 'member')
    currency.api_new_player(player_class,user,user.full_name)
  end

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # You can also declare which fixtures to use (for example fixtures for test/fixtures):
  #
  # config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  #
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  # 
  # For more information take a look at Spec::Runner::Configuration and Spec::Runner
end
