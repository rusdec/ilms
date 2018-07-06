require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:surname) }

  it { should validate_length_of(:name).is_at_least(2).is_at_most(20) }
  it { should validate_length_of(:surname).is_at_least(2).is_at_most(20) }

  it { should have_many(:courses) }
  it { should have_many(:lessons) }

  it { should allow_values('User', 'Administrator', 'CourseMaster').for(:type) }
  it { should_not allow_values('Userr', 'Rdministrator', 'ourseMaster').for(:type) }

  describe '.admin?' do
    %w(User CourseMaster).each do |role|
      it "should be false when #{role}" do
        expect(create(role.underscore.to_sym)).to_not be_admin
      end
    end

    it 'should be true when Administator' do
      expect(create(:administrator)).to be_admin
    end
  end

  describe '.course_master?' do
    it 'should be false when User' do
      expect(create(:user)).to_not be_course_master
    end

    %w(Administrator CourseMaster).each do |role|
      it "should be true when #{role}" do
        expect(create(role.underscore.to_sym)).to be_course_master
      end
    end
  end

  it '.full_name' do
    user = create(:user)
    expect(user.full_name).to eq("#{user.name} #{user.surname}")
  end
end