shared_examples_for 'educable' do
 it { should have_many(:passages).dependent(:destroy) }

 it '.learning?' do
    course = create(:course)
    create(:passage, user: educable, passable: course)
    expect(educable).to be_learning(course)
  end

 it '.learned_courses' do
   courses = create_list(:course, 2)
   courses.each { |course| create(:passage, user: educable, passable: course) }
   create(:course)
  
   expect(educable.learned_courses).to eq(courses)
 end
end
