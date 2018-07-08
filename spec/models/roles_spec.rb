require 'rails_helper'

RSpec.describe Role do
  it '#all' do
    expect(Role.all).to eq %w(User CourseMaster Administrator)
  end
end
