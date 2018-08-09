shared_examples_for 'passable' do
  it { should have_many(:passages).dependent(:destroy) }
end
