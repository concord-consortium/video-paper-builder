
if ENV['COVERAGE_REPORT']
  require 'simplecov'
  SimpleCov.start do
    add_filter '/config/'
    add_filter '/db/'
    add_filter '/doc/'
    add_filter '/features/'
    add_filter "/log/"
    add_filter "/public/"
    add_filter "/script/"
    add_filter '/spec/'
    add_filter '/tmp/'
    add_filter '/vendor/'
  end
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'devise'

require_relative 'spec_helper_common'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.include Devise::TestHelpers, :type => :controller

  # rspec-rails 3 will no longer automatically infer an example group's spec type
  # from the file location. You can explicitly opt-in to the feature using this
  # config option.
  # To explicitly tag specs without using automatic inference, set the `:type`
  # metadata manually:
  #
  #     describe ThingsController, :type => :controller do
  #       # Equivalent to being in spec/controllers
  #     end
  config.infer_spec_type_from_file_location!
end

# this disables the new FactoryBot 5 behavour where FactoryBot.build(...) no longer
# builds associations to other factories causing many of the section spect tests to
# fail as the video_paper association is nil
# TODO: look again at how factories are modeled to try to get associations created
# during build (I couldn't get this to work which is why I set this option to
# use the pre-FactoryBot 5 behavior as noted in their docs)
FactoryBot.use_parent_strategy = false