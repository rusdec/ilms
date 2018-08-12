require_relative 'models_helper'

RSpec.describe LessonPassage, type: :model do
  let!(:course) { create(:course, :full) }
  let!(:passage) { create(:passage, passable: course) }
  let(:lesson_passage) { LessonPassage.first }

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
