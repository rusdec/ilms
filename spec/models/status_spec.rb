require_relative 'models_helper'

RSpec.describe Status, type: :model do
  context '#method_missing' do
    context 'when status finded' do
      it 'return status finded by mising method_name' do
        status_in_progress = create(:status, :in_progress)
        expect(Status.in_progress).to eq(status_in_progress)
      end
    end

    context 'when status not finded' do
      it 'return nil' do
        expect(Status.in_progress).to be_nil
      end
    end
  end
end
