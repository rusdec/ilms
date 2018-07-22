require_relative 'models_helper'

RSpec.describe QuestPassage, type: :model do
  it { should belong_to(:lesson_passage) }
  it { should belong_to(:quest) }
  it { should have_many(:quest_solutions).dependent(:destroy) }
end
