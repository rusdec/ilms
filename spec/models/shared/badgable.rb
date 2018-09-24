shared_examples_for 'badgable' do
  it { should have_one(:badge).dependent(:destroy) }
end
