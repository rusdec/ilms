require_relative 'models_helper'

RSpec.describe QuestSolution, type: :model do
  it { should belong_to(:quest_passage) }

  let(:html_validable) do
    { field: :body, object: create(:quest_solution) }
  end
  it_behaves_like 'html_presence_validable'

  it_behaves_like 'html_attributable', %i(body)
end
