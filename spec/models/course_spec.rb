require 'rails_helper'

RSpec.describe Course, type: :model do
  it { should validate_presence_of(:title) }
  it { should belong_to(:author).with_foreign_key('user_id').class_name('User') }

  it { should validate_length_of(:title).is_at_least(5).is_at_most(50) }
  it { should have_many(:lessons).dependent(:destroy) }

  it_behaves_like 'html_attributable', %w(decoration_description)

  let(:administrator) { create(:administrator) }

  it 'should be default level value' do
    course = create(:course, user_id: administrator.id)
    expect(course.level).to eq(1)
  end

  it 'should be default decoration_description value' do
    course = create(:course, user_id: administrator.id)
    expect(course.decoration_description).to be_empty
  end

  context 'when author have User role' do
    let!(:course) { build(:course, user_id: create(:user).id) }

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
      course = build(:course, user_id: create(role.underscore.to_sym).id)
      expect(course).to be_valid
    end
  end
end
