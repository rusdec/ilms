require_relative '../features_helper'

feature 'Show course', %q{
  As User
  I can see a detail course
  so that I can read detail information
} do

  let(:user) { create(:user) }
  let!(:course) { create(:course, user_id: create(:course_master).id) }
  
  before do
    sign_in(user)
    visit course_path(course)
  end

  scenario 'can view detail page' do
    [course.title,
     course.author.full_name,
     course.decoration_description,
     date_format(course.created_at),
    ].each { |text| expect(page).to have_content(text) }
  end
end
