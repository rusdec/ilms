require_relative '../models_helper'

RSpec.describe Statusable, type: :model do
  with_model :any_statusable do
    table do |t|
      t.integer :status_id
    end

    model do
      include Statusable
    end
  end
  before { create(:status, :in_progress) }

  context '.default_status' do
    it 'return Status object' do
      statusable = AnyStatusable.create
      expect(statusable.send :default_status).to eq(Status.find(:in_progress))
    end
  end

  context '.set_status' do
    it 'set status to default_status' do
      statusable = AnyStatusable.new
      statusable.send :set_status
      expect(statusable.status).to eq(statusable.send :default_status)
    end

    it 'receive set_status before_validation' do
      statusable = AnyStatusable.new
      expect(statusable).to receive(:set_status)
      statusable.valid?
    end
  end
end
