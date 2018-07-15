require 'rails_helper'

RSpec.describe Material, type: :model do
  it { should belong_to(:author).with_foreign_key(:user_id).class_name('User') }
  it { should belong_to(:lesson) }

  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_least(10) }
end
