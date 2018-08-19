require_relative '../../features_helper'

feature 'Create badge', %q{
  As Course Master
  I can create badge for quest
  so that students can get it
} do
  it_behaves_like 'badgable' do
    given(:badgable) { create(:quest) }
  end
end
