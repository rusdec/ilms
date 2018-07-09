require 'rails_helper'

RSpec.describe Role do
  it '#all' do
    [create(:user), create(:course_master), create(:administrator)]
    expect(Role.all).to eq %w(User CourseMaster Administrator)
  end
end
