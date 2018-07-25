require 'rails_helper'

RSpec.describe QuestSolutionDecorator do
  let!(:quest_solution) { QuestSolutionDecorator.new(create(:quest_solution)) }

  context '.status' do
    it 'when unverified return unverified' do
      expect(quest_solution.status).to eq('unverified')
    end

    it 'when accepted return accepted' do
      quest_solution.accept!
      expect(quest_solution.status).to eq('accepted')
    end

    it 'when decline return decline' do
      quest_solution.decline!
      expect(quest_solution.status).to eq('decline')
    end
  end
end
