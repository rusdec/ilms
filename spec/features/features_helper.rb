require 'rails_helper'
require 'capybara/rspec'

Dir[Rails.root.join('spec/features/shared/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include Features::SigningMacros
  config.include Features::CourseMasterMacros::CoursesMacros
  config.include Features::CourseMasterMacros::Shared
  config.include Features::SharedMacros
  config.include Features::KnowledgeMacros
  config.include Features::KnowledgeDirectionMacros

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
