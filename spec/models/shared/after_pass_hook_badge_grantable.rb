# Variables
#   @params Passage passage => any Passage (Passage, QuestPassage, LessonPassage, etc)
shared_examples_for 'after_pass_hook_badge_grantable' do
  context '.after_pass_hook' do
    let(:user) { passage.user }

    context 'when passable (quest) have badge' do
      before do
        create(:badge, badgable: passage.passable)
        allow(passage).to receive(:ready_to_pass?).and_return(true)
      end

      it 'user receives reward! with badge' do
        expect(user).to receive(:reward!).with(passage.passable.badge)
        passage.try_chain_pass!
      end
    end

    context 'when passable have not badge' do
      it 'user does not receives reward!' do
        expect(user).to_not receive(:reward!)
        passage.try_chain_pass!
      end
    end
  end # context '.after_pass_hook'
end
