require_relative '../models_helper'

RSpec.describe Rewardable, type: :model do
  with_model :any_grantable do
    model do
      include Grantable
    end
  end

  let!(:rewardable) { create(:user) }
  let!(:grantable) { AnyGrantable.create }

  context '.reward!' do
    it 'relates rewardable with grantable' do
      rewardable.reward!(grantable)
      expect(
        rewardable.user_grantables.last.grantable
      ).to eq(grantable)
    end
  end

  context '.collected_course_badges' do
    let!(:course) { create(:course) }

    before do
      create(:passage, passable: course, user: rewardable)
      create(:badge, course: course, badgable: course)
      CoursePassage.last.passed!
    end
    
    it 'returns all opened badges for given course for all passages' do
      expect(
        rewardable.collected_course_badges(course)
      ).to eq(rewardable.badges)
    end

    it 'not returns opened badges for passages for other course' do
      other_course = create(:course)
      create(:passage, passable: other_course, user: rewardable)
      create(:badge, course: other_course, badgable: other_course)
      CoursePassage.last.passed!

      expect(
        rewardable.collected_course_badges(course)
      ).to_not be_include(Badge.find_by(course: other_course))
    end
  end

  
  context '.collected_hidden_course_badges' do
    let!(:course) { create(:course) }

    before { create(:passage, passable: course, user: rewardable) }
    
    it 'returns all opened hidden badges for given course for all passages' do
      create(:badge, course: course, badgable: course, hidden: true)
      CoursePassage.last.passed!

      expect(
        rewardable.collected_course_hidden_badges(course)
      ).to eq(rewardable.badges)
    end

    it 'not returns not hidden badges' do
      create(:badge, course: course, badgable: course, hidden: false)
      CoursePassage.last.passed!

      expect(
        rewardable.collected_course_hidden_badges(course)
      ).to eq([])
    end
  end
end
