require 'rails_helper'

RSpec.describe BadgeBadgable, type: :model do
  it { should belong_to(:badgable) }
  it { should belong_to(:badge) }
end
