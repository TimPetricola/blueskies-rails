ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'database_cleaner'
require 'webmock/minitest'

require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use!(Minitest::Reporters::DefaultReporter.new(color: true))

WebMock.allow_net_connect!
WebMock.disable_net_connect!(allow_localhost: true)

class ActiveSupport::TestCase
  before(:each) { DatabaseCleaner.start }
  after(:each) { DatabaseCleaner.clean }
end
