require 'rails_helper'
require 'capybara/rspec'

RSpec.configure do |config|
  config.include Features::Signing
end
