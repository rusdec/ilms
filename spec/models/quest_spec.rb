require_relative 'models_helper'

RSpec.describe Quest, type: :model do
  it { should have_one(:course).through(:lesson) }
  it { should validate_presence_of(:title) }
  it do
    should validate_length_of(:title)
             .is_at_least(3)
             .is_at_most(50)
  end

  it { should validate_presence_of(:description) }
  it do
    should validate_length_of(:description)
             .is_at_least(10)
             .is_at_most(500)
  end

  let(:html_validable) { { field: :body, object: create(:quest), minimum: 10 } }
  it_behaves_like 'html_length_minimum_validable'
  it_behaves_like 'html_presence_validable'

  it_behaves_like 'passable'
  it_behaves_like 'authorable'
  it_behaves_like 'badgable'
  it_behaves_like 'difficultable'

  it { should belong_to(:lesson) }
  it { should belong_to(:quest_group) }
  it do
    should belong_to(:old_quest_group)
      .with_foreign_key('old_quest_group_id')
      .class_name('QuestGroup')
  end

  context 'Using quest_group parameter' do
    let!(:quest) { create(:quest) }

    context '.alternatives' do
      it 'should have 5 alternative quests' do
        alternatives = create_list(:quest, 5, lesson: quest.lesson,
                                              author: quest.author,
                                              quest_group: quest.quest_group)

        expect(quest.alternatives).to eq(alternatives)
      end
    end

    context '.has_alternatives' do
      it 'should have alternatives' do
        create_list(:quest, 5, lesson: quest.lesson,
                               author: quest.author,
                               quest_group: quest.quest_group)

        expect(quest).to have_alternatives
      end

      it 'should not have alternatives' do
        expect(quest).to_not have_alternatives
      end
    end
  end

  context 'create' do
    context 'before_create_set_quest_group' do
      let!(:user) { create(:course_master, :with_course_and_lesson) }
      let(:lesson) { user.lessons.last }

      it 'create new quest_group' do
        expect{
          create(:quest, lesson: lesson, author: lesson.author)
        }.to change(lesson.quest_groups, :count).by(1)
      end

      it 'created quest_group related with quest' do
        quest = create(:quest, lesson: lesson, author: lesson.author)
        expect(quest.quest_group).to_not be_nil
      end

      it 'old_quest_group equal quest_group' do
        quest = create(:quest, lesson: lesson, author: lesson.author)
        expect(quest.old_quest_group).to eq(quest.quest_group)
      end

      it 'can\'t create new quest group if it given' do
        quest_group = create(:quest_group, lesson: lesson)
        expect{
          create(:quest, lesson: lesson,
                         author: lesson.author,
                         quest_group: quest_group)
        }.to_not change(lesson.quest_groups, :count)
      end
    end
  end

  context 'update' do
    context 'after_update_delete_old_quest_group_if_empty' do
      let(:lesson) { create(:course_master, :with_course_and_lesson).lessons.last }
      let!(:quests) { create_list(:quest, 2, lesson: lesson, author: lesson.author) }
      let(:quest) { quests.first }

      it 'old_quest_group receive destroy' do
        expect(quest.old_quest_group).to receive(:destroy)
        quest.update(quest_group: quests.last.quest_group)
      end

      it 'old_quest_group not receive destroy' do
        create(:quest, lesson: lesson,
                       author: lesson.author,
                       quest_group: quest.quest_group)
        expect(quest.old_quest_group).to_not receive(:destroy)
        quest.update(quest_group: quests.last.quest_group)
      end

      it 'old_quest_group will equal quest_group' do
        quest.update(quest_group: quests.last.quest_group)
        quest.reload
        expect(quest.old_quest_group).to eq(quest.quest_group)
      end

      context 'when given quest_group is nil' do
        it 'create new quest_group' do
          expect{
            quest.update(quest_group: nil)
          }.to_not change(lesson.quest_groups, :count)
        end

        it 'new quest_group related with quest' do
          quest.update(quest_group: nil)
          quest.reload
          expect(quest.quest_group).to eq(lesson.quest_groups.last)
        end
      end
    end
  end

  context 'destroy' do
    context 'after_destroy_delete_quest_group_if_empty' do
      let(:lesson) { create(:course_master, :with_course_and_lesson).lessons.last }
      let!(:quest) { create(:quest, lesson: lesson, author: lesson.author) }

      it 'delete quest group if it is empty' do
        expect(quest.quest_group).to receive(:destroy)
        quest.destroy
      end
    end
  end
end
