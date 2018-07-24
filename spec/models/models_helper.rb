require 'rails_helper'
require 'with_model'

Dir[Rails.root.join('spec/models/concerns/**/*.rb')].each { |f| require f }
Dir[Rails.root.join('spec/models/shared/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.extend WithModel
end
