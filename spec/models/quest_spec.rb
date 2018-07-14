require 'rails_helper'

RSpec.describe Quest, type: :model do
  it { should validate_presence_of(:title) }
  it do
    should validate_length_of(:title).is_at_least(3).is_at_most(50)
  end

  it { should validate_presence_of(:description) }
  it do
    should validate_length_of(:description).is_at_least(10).is_at_most(1000)
  end

  it do
    should validate_numericality_of(:level)
      .only_integer
      .is_greater_than_or_equal_to(1)
      .is_less_than_or_equal_to(5)
  end

  it { should belong_to(:author).with_foreign_key('user_id').class_name('User') }
  it { should belong_to(:lesson) }
  it { should belong_to(:quest_group) }

  context 'Using quest_group parameter' do
    let(:user) { create(:course_master, :with_course_and_lesson) }
    let(:lesson) { user.lessons.last }
    let(:quest_group) { create(:quest_group, lesson: lesson) }
    let(:params) { { lesson: lesson, quest_group: quest_group, author: user } }

    context '.alternatives' do
      it 'should have 5 alternative quests' do
        quest = create(:quest, params)
        quests = create_list(:quest, 5, params)
        params[:quest_group] = create(:quest_group, lesson: lesson)
        create_list(:quest, 3, params)

        expect(quest.alternatives).to eq(quests)
      end
    end

    context '.has_alternatives' do
      it 'should have alternatives' do
        create_list(:quest, 5, params)
        expect(create(:quest, params)).to have_alternatives
      end

      it 'should not have alternatives' do
        expect(create(:quest, params)).to_not have_alternatives
      end
    end
  end
end
