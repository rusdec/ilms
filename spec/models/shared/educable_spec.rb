shared_examples_for 'educable' do
  it { should have_many(:course_passages).dependent(:destroy) }
  it { should have_many(:lesson_passages) }
end
