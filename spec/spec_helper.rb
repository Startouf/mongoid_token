require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

$: << File.expand_path('../../lib', __FILE__)

require 'mongoid_cleaner'
require 'mongoid'
require 'mongoid-rspec'
require 'mongoid_token'

ENV['MONGOID_ENV'] = "test"

RSpec.configure do |config|
  Mongo::Logger.logger.level = Logger::ERROR

  config.include Mongoid::Matchers
  config.before(:suite) do
    MongoidCleaner.strategy = :drop
  end

  config.around(:each) do |example|
    MongoidCleaner.cleaning do
      example.run
    end
  end
end

Mongoid.configure do |config|
  config.connect_to('mongoid_token_test', {})
end
