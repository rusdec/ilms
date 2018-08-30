require_relative 'models_helper'

RSpec.describe CoursePassage, type: :model do
  let!(:course) { create(:course, :full) }
  let(:course_passage) { create(:course_passage, passable: course) }
  let(:user) { course_passage.user }

  it { should have_many(:quest_passages).through(:children).source(:children) }
  it_behaves_like 'after_pass_hook_badge_grantable' do
    let(:passage) { course_passage }
  end

  context 'create_user_knowledges' do
    it 'relates course knowledges with user' do
      expect(user.knowledges).to eq(course.knowledges)
    end
  end

  context 'alias_attributes' do
    it '.lesson_passages' do
      expect(course_passage.lesson_passages).to eq(course_passage.children)
    end

    it '.course' do
      expect(course_passage.course).to eq(course_passage.passable)
    end
  end

  context '.passed_quest_passages' do
    before do
      course_passage
      QuestPassage.first.passed!
    end

    it 'returns passed quest for course' do
      expect(
        course_passage.passed_quest_passages
      ).to eq(QuestPassage.all_passed)
    end
  end

  context '.passed_lesson_passages' do
    before do
      course_passage
      LessonPassage.first.passed!
    end

    it 'returns passed quest for course' do
      expect(
        course_passage.passed_lesson_passages
      ).to eq(LessonPassage.all_passed)
    end
  end

  context '.default_status' do
    it 'should be in_progress' do
      expect(course_passage.status).to eq(Status.in_progress)
    end
  end

  context '.ready_to_pass?' do
    before { course_passage }

    context 'when each child (lesson passage) is passed' do
      before { LessonPassage.all.each(&:passed!) }

      it 'returns true' do
        expect(course_passage).to be_ready_to_pass
      end
    end

    context 'when has non-passed child (lesson passage)' do
      it 'returns false' do
        expect(course_passage).to_not be_ready_to_pass
      end
    end
  end
end
