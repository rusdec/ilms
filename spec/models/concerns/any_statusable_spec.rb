require_relative '../models_helper'

RSpec.describe Statusable, type: :model do
  with_model :any_statusable do
    table { |t| t.integer :status_id }
    model { include Statusable }
  end

  let!(:statusable) { AnyStatusable.create }

  context '.statuses' do 
    it 'should return Status' do
      expect(statusable.statuses).to eq(Status)
    end
  end

  context 'define methods for find all row by status' do
    Status.all.each do |status|
      context "#all_#{status.name}" do
        before do
          ['accepted!', "#{status.name}!"].each do |s|
            5.times do
              AnyStatusable.create
              AnyStatusable.last.send s
            end
          end
        end

        it "should return all #{status.name}" do
          expect(
            AnyStatusable.send "all_#{status.name}"
          ).to eq(AnyStatusable.where(status: Status.send(status.name)))
        end
      end
    end
  end # context 'define methods for find rows by status'

  context 'define methods for check current status' do
    Status.where.not(name: 'in_progress').each do |status|
      context "#{status.name}?" do
        context "when status is not same" do
          it "should return false" do
            expect(statusable.send "#{status.name}?").to_not eq(true)
          end
        end
        
        context "when status is same" do
          it "should return true" do
            statusable.send "#{status.name}!"
            expect(statusable.send "#{status.name}?").to eq(true)
          end
        end
      end
    end
  end

  context 'define methods for update statuse' do
    Status.all.each do |status|
      context ".#{status.name}!" do
        it "update status to #{status.name}" do
          statusable.send "#{status.name}!"
          expect(statusable.status).to eq(Status.send status.name)
        end
      end
    end
  end

  context 'when update status' do
    %i(before_update_status after_update_status).each do |method|
      it "receive #{method}" do
        expect(statusable).to receive(method)
        statusable.declined!
      end
    end
  end

  context 'before create' do
    let!(:statusable) { AnyStatusable.new }

    it 'set status to default_status' do
      statusable.send :before_create_set_status
      expect(statusable.status).to eq(statusable.send :default_status)
    end

    it 'receive set_status before create' do
      expect(statusable).to receive(:before_create_set_status)
      statusable.save
    end
  end
end
