require_relative '../models_helper'

RSpec.describe Statusable, type: :model do
  with_model :any_statusable do
    table { |t| t.integer :status }
    model { include Statusable }
  end

  let!(:statusable) { AnyStatusable.create }

  context '.statuses' do 
    it 'should return Status' do
      expect(statusable.statuses).to eq(AnyStatusable.statuses)
    end
  end

  context 'define methods for find all row by status' do
    [:in_progress, :passed, :failed, :accepted,
     :declined, :unverified, :unavailable].each do |status|
      context "#all_#{status}" do
        before do
          ['accepted!', "#{status}!"].each do |s|
            5.times do
              AnyStatusable.create
              AnyStatusable.last.send s
            end
          end
        end

        it "should return all #{status}" do
          expect(
            AnyStatusable.send "all_#{status}"
          ).to eq(AnyStatusable.where(status: status))
        end
      end
    end
  end # context 'define methods for find rows by status'

  context 'when update status' do
    it "receive after_update_status_hook" do
      expect(statusable).to receive(:after_update_status_hook)
      statusable.declined!
    end
  end

  context 'before create' do
    let!(:statusable) { AnyStatusable.new }

    it 'set status to default_status' do
      statusable.send :before_create_set_status
      expect(statusable.status).to eq((statusable.send(:default_status)).to_s)
    end

    it 'receive set_status before create' do
      expect(statusable).to receive(:before_create_set_status)
      statusable.save
    end
  end
end
