require_relative 'models_helper'

RSpec.describe CoursePassage, type: :model do
  let!(:course) { create(:course, :full) }
  before { create(:passage, passable: course) }
  let!(:course_passage) { CoursePassage.first }

  it_behaves_like 'after_pass_hook_badge_grantable' do
    let(:passage) { course_passage }
  end

  context '.default_status' do
    it 'should be in_progress' do
      expect(course_passage.status). to eq(Status.in_progress)
    end
  end

  context '.ready_to_pass?' do
    context 'when each child (lesson passage) is passed' do
      before { LessonPassage.all.each(&:passed!) }

      it 'should return true' do
        expect(course_passage).to be_ready_to_pass
      end
    end

    context 'when has non-passed child (lesson passage)' do
      it 'should return false' do
        expect(course_passage).to_not be_ready_to_pass
      end
    end
  end
end
