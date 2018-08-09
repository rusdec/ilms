shared_examples_for 'educable' do
 it { should have_many(:passages).dependent(:destroy) }

 it '.learning?' do
    course = create(:course)
    create(:passage, user: educable, passable: course)
    expect(educable).to be_learning(course)
  end
end
