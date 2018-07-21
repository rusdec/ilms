require 'rails_helper'

RSpec.describe QuestGroup, type: :model do
  it { should belong_to(:lesson) }
  it { should have_many(:quests) }
  it { should have_many(:quest_passages) }

  context '.empty?' do
    let!(:lesson) { create(:course_master, :with_course_and_lesson).lessons.last }
    let(:quest_group) { create(:quest_group, lesson: lesson) }

    it 'should be empty' do
      expect(quest_group).to be_empty
    end

    it 'should not be empty' do
      create(:quest, author: lesson.author, lesson: lesson, quest_group: quest_group)
      expect(quest_group).to_not be_empty
    end
  end

  context '.destroy_if_empty' do
    let!(:lesson) { create(:course_master, :with_course_and_lesson).lessons.last }
    let(:quest_group) { create(:quest_group, lesson: lesson) }

    it 'should be destroyed' do
      quest_group.destroy_if_empty
      expect(quest_group).to_not be_persisted
    end

    it 'should not be destroyed' do
      create(:quest, author: lesson.author, lesson: lesson, quest_group: quest_group)
      quest_group.destroy_if_empty
      expect(quest_group).to be_persisted
    end
  end

  context '.siblings' do
    let!(:lesson) { create(:course_master, :with_course_and_lesson).lessons.last }
    let(:quest_group) { create(:quest_group, lesson: lesson) }
    let!(:quest_groups) { create_list(:quest_group, 3, lesson: lesson) }

    it 'should be 3 quest_group-siblings' do
      expect(quest_group.siblings).to eq(quest_groups)
    end
  end
end
