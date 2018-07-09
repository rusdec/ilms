require 'rails_helper'
require 'json_matchers/rspec'

JsonMatchers.schema_root = 'spec/support/schemas'

RSpec.configure do |config|
  config.include JsonResponsedMacros
end
