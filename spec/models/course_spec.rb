require_relative 'models_helper'

RSpec.describe Course, type: :model do
  it { should validate_presence_of(:title) }

  it { should validate_length_of(:title).is_at_least(5).is_at_most(50) }
  it { should have_many(:lessons).dependent(:destroy) }
  it { should have_many(:quests).through(:lessons) }

  it_behaves_like 'passable'
  it_behaves_like 'badgable'
  it_behaves_like 'authorable'

  let(:administrator) { create(:administrator) }

  it 'should be default level value' do
    expect(create(:course).level).to eq(1)
  end

  it 'should be default decoration_description value' do
    expect(create(:course).decoration_description).to be_empty
  end

  context 'alias attributes' do
    it 'returns self' do
      course = create(:course)
      expect(course.course).to eq(course)
    end

    it '.passable_children' do
      course = create(:course, :with_lessons)
      expect(course.passable_children).to eq(course.lessons)
    end
  end

  context 'when author have User role' do
    let!(:course) { build(:course, author: create(:user)) }

    it 'should not be ivalid' do
      expect(course).to_not be_valid
    end

    it 'should contain error' do
      course.validate
      expect(course.errors[:user]).to eq(['can\'t do this'])
    end
  end

  %w(Administrator CourseMaster).each do |role|
    it "should be valid if author have #{role} role" do
      expect(build(:course, author: create(role.underscore.to_sym))).to be_valid
    end
  end

  context '#all_published' do
    let!(:published_courses) { create_list(:course, 3) }
    let!(:unpublised_courses) { create_list(:course, 3, :unpublished) }

    it 'returns all published courses' do
      expect(Course.all_published).to eq(published_courses)
    end
  end
end
