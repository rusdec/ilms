require_relative 'models_helper'

RSpec.describe LessonPassage, type: :model do
  let!(:course) { create(:course, :full) }
  let!(:passage) { create(:passage, passable: course) }
  let(:lesson_passage) { LessonPassage.last }

  context '.default_status' do
    it 'should be unavailable' do
      expect(lesson_passage.status).to eq(Status.unavailable)
    end
  end

  context '.open_passage_if_root' do
    let!(:lesson) { create(:lesson, course: course) }
    let!(:lesson_passage) do
      build(:lesson_passage, passable: lesson, user: passage.user)
    end

    context 'when lesson (passable) is root lesson' do
      it 'should receive in_progress!' do
        expect(lesson_passage).to receive(:in_progress!)
        lesson_passage.save
      end
    end

    context 'when lesson (passable) is not root lesson' do
      before { lesson.update(parent: course.lessons.last) }

      it 'should not receive in_progress!' do
        expect(lesson_passage).to_not receive(:in_progress!)
        lesson_passage.save
      end
    end
  end

  context '.ready_to_pass?' do
    context 'when each quest group has one passed quest' do
      it 'should return true' do
        lesson_passage.passable.quest_groups.each do |quest_group|
          lesson_passage.children.find_by(passable: quest_group.quests.first).passed!
        end

        expect(lesson_passage).to be_ready_to_pass
      end
    end

    context 'when few quest groups has not passed quest' do
      it 'should return false' do
        lesson_passage.passable.quest_groups[0..-2].each do |quest_group|
          lesson_passage.children.find_by(passable: quest_group.quests.first).passed!
        end

        expect(lesson_passage).to_not be_ready_to_pass
      end
    end
  end
end
