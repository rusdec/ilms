require_relative 'models_helper'

RSpec.describe Status, type: :model do
  context '#method_missing' do
    context 'when status finded' do
      it 'return status finded by mising method_name' do
        status_existed = create(:status, name: 'existed')
        expect(Status.existed).to eq(status_existed)
      end
    end

    context 'when status not finded' do
      it 'return nil' do
        expect(Status.not_existed).to be_nil
      end
    end
  end
end
