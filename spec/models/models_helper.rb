require 'rails_helper'
require 'with_model'
require 'closure_tree/test/matcher'

Dir[Rails.root.join('spec/models/shared/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.extend WithModel
end
