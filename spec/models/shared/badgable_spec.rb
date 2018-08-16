shared_examples_for 'badgable' do
  it { should have_one(:badge_badgable) }
  it { should have_one(:badge).through(:badge_badgable) }
end
