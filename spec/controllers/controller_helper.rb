require 'rails_helper'
require 'json_matchers/rspec'
require 'with_model'

JsonMatchers.schema_root = 'spec/support/schemas'

Dir[Rails.root.join('spec/controllers/shared/**/*.rb')].each { |f| require f }

# Load Statuses
Rails.application.load_seed

RSpec.configure do |config|
  config.include JsonResponsedMacros
  config.extend WithModel
end
