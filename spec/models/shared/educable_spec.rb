shared_examples_for 'educable' do
  it { should have_many(:passages).dependent(:destroy) }

  it '.learning?' do
    course = create(:course)
    create(:passage, user: educable, passable: course)
    expect(educable).to be_learning(course)
  end

  it { should have_many(:passaged_courses).through(:passages).source(:passable) }
  it { should have_many(:passaged_lessons).through(:passages).source(:passable) }
  it { should have_many(:passaged_quests).through(:passages).source(:passable) }
  it do
    should have_many(:passed_passages)
      .class_name('Passage')
      .conditions(status: :passed)
  end
  it do
    should have_many(:in_progress_passages)
      .class_name('Passage')
      .conditions(status: :in_progress)
  end
  it do
    should have_many(:unavailable_passages)
      .class_name('Passage')
      .conditions(status: :unavailable)
  end
  it { should have_many(:passed_courses).through(:passed_passages).source(:passable) }
  it { should have_many(:passed_lessons).through(:passed_passages).source(:passable) }
  it { should have_many(:passed_quests).through(:passed_passages).source(:passable) }
  it do
    should have_many(:in_progress_courses)
      .through(:in_progress_passages)
      .source(:passable)
  end
  it do
    should have_many(:in_progress_lessons)
      .through(:in_progress_passages)
      .source(:passable)
  end
  it do
    should have_many(:unavailable_lessons)
      .through(:unavailable_passages)
      .source(:passable)
  end
  it do
    should have_many(:in_progress_quests)
      .through(:in_progress_passages)
      .source(:passable)
  end
end
