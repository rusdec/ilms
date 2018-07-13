require 'rails_helper'

RSpec.describe AlternativeQuest, type: :model do
  it { should belong_to(:quest) }
  it { should belong_to(:alternative_quest).class_name('Quest') }

  it 'validate refer to himself' do
    lesson = create(:course_master, :with_course_and_lesson).lessons.last
    quests = create_list(:quest, 2, lesson: lesson, author: lesson.author)
    alternative_quest = build(:alternative_quest,
                              quest: quests.first,
                              alternative_quest: quests.first)

    expect(alternative_quest).to_not be_valid
  end
end
