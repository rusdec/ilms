require_relative '../../features_helper'

feature 'Create badge', %q{
  As Course Master
  I can create badge for course
  so that students can get it
} do
  it_behaves_like 'badgable' do
    given(:badgable) { create(:course) }
    given(:new_badgable_path) { new_course_master_course_path }
  end
end
