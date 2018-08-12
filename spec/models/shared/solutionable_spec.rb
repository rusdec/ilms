shared_examples_for 'solutionable' do
  it { should have_many(:solutions).class_name('PassageSolution').dependent(:destroy) }
end
