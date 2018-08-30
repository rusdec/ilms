require 'rails_helper'

RSpec.describe UserKnowledge, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:knowledge) }

  it do
    # Bug with validate_uniqueness_of and scoped_to
    # https://github.com/thoughtbot/shoulda-matchers/issues/682#issuecomment-187767983
    subject = create(:user_knowledge)
    is_expected.to validate_uniqueness_of(:knowledge_id)
      .scoped_to(:user_id)
      .with_message('should be once per user')
  end

  it { should have_db_index([:user_id, :knowledge_id]).unique }
end
