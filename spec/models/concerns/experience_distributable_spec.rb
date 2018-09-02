require_relative '../models_helper'

RSpec.describe ExperienceDistributable, type: :model do
  with_model :any_experience_distributable do
    table do |t|
      t.integer :user_id
    end

    model do
      include ExperienceDistributable
      belongs_to :user
    end
  end

  let(:user) { create(:user) }
  let(:history) { create(:knowledge, name: 'history') }
  let(:math) { create(:knowledge, name: 'math') }

  let!(:any_experience_distributable) { AnyExperienceDistributable.create(user: user) }

  before do
    create(:course_knowledge, percent: 20, knowledge: history)
    create(:course_knowledge, percent: 80, knowledge: math)
    allow(any_experience_distributable).to receive(:course_knowledges) do
      CourseKnowledge.where(knowledge: [math, history])
    end
    allow(any_experience_distributable).to receive(:experience) { 100 }
  end

  let!(:user_history) { create(:user_knowledge, user: user, knowledge: history) }
  let!(:user_math) { create(:user_knowledge, user: user, knowledge: math) }

  context '.destribute_experience_between_knowledges' do
    before { any_experience_distributable.destribute_experience_between_knowledges }

    it 'update experience of history by 20' do
      user_history.reload
      expect(user_history.experience).to eq(20)
    end

    it 'update experience of math by 80' do
      user_math.reload
      expect(user_math.experience).to eq(80)
    end
  end
end
