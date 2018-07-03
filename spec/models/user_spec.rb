require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:surname) }

  it { should validate_length_of(:name).is_at_least(2).is_at_most(20) }
  it { should validate_length_of(:surname).is_at_least(2).is_at_most(20) }

  describe '.admin?' do
    it 'when User should be false' do
      expect(create(:user)).to_not be_admin
    end

    it 'when CourseMaster should be false' do
      expect(create(:course_master)).to_not be_admin
    end

    it 'when Administator should be true' do
      expect(create(:admin)).to be_admin
    end
  end

  describe '.course_master?' do
    it 'when User should be false' do
      expect(create(:user)).to_not be_course_master
    end

    it 'when CourseMaster should be true' do
      expect(create(:course_master)).to be_course_master
    end

    it 'when Administator should be true' do
      expect(create(:admin)).to be_course_master
    end
  end
end
