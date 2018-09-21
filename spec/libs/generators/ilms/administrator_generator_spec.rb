require 'rails_helper'

describe Ilms::AdministratorGenerator, type: :generator do
  context 'when valid data' do
    let!(:generator) do
      Ilms::AdministratorGenerator.new(nil, {
        email: 'example@email.ru',
        password: 'qwerty123'
      })
    end

    it 'creates administrator' do
      expect{
        capture { generator.invoke_all }
      }.to change(Administrator, :count).by(1)
    end

    it 'administrator has given email' do
      capture { generator.invoke_all }
      expect(Administrator.last.email).to eq('example@email.ru')
    end

    it 'puts ok message' do
      expect(
        capture { generator.invoke_all }
      ).to eq(['ok  administrator was created'])
    end
  end # context 'when data valid'

  context 'when invalid data' do
    let!(:generator) do
      Ilms::AdministratorGenerator.new(nil, { email: nil,  password: nil })
    end

    it 'can\'t create administrator' do
      expect{
        capture { generator.invoke_all }
      }.to_not change(Administrator, :count)
    end

    it 'puts error messages' do
      expect(
        capture { generator.invoke_all }
      ).to eq(['error  Email can\'t be blank', 'error  Password can\'t be blank'])
    end
  end
end
