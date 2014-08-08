
ENV["RUBY_ENV"] = "test"
require 'factory_girl'
require "minitest/autorun"
require 'mocha/setup'
require "minitest/pride"
require 'mocha/setup'

require_relative './factories/factories'

class MiniTest::Unit::TestCase
  include FactoryGirl::Syntax::Methods
end


require_relative('../config/configure')