require_relative '../models_helper'

RSpec.describe Statusable, type: :model do
  before do
    %i(in_progress declined accepted).each { |status| create(:status, status) }
  end

  with_model :any_statusable do
    table { |t| t.integer :status_id }
    model { include Statusable }
  end

  context 'define methods for check current status' do
    let!(:statusable) { AnyStatusable.create }
    context "when status is in_progress" do
      %i(declined accepted).each do |status|
        it "#{status}? should return false" do
          expect(statusable.send "#{status}?").to_not eq(true)
        end
      end

      it 'in_progress? should return true' do
        expect(statusable).to be_in_progress
      end
    end
  end

  context 'define methods for update statuse' do
    let!(:statusable) { AnyStatusable.create }
    %i(in_progress declined accepted).each do |status|
      it "#{status}! update status to #{status}" do
        statusable.send "#{status}!"
        expect(statusable.status).to eq(Status.send status)
      end
    end
  end

  context 'when update status' do
    let!(:statusable) { AnyStatusable.create }
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
