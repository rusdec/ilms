shared_examples_for 'badge_author' do
  it { should have_many(:created_badges).class_name('Badge') }
end
