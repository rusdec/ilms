require_relative 'validators_helper'

RSpec.describe HtmlValidator, type: :model do
  context '.validate_length' do
    with_model :any_htmlable do
      table { |t| t.text :body }
      model do
        validates :body, html: { length: { minimum: 5, maximum: 8 } }
      end
    end

    let!(:htmlable) { AnyHtmlable.new }

    context '.validate_length_minimum' do
      context 'when valid' do
        before { htmlable.body = '<p>12345</p>' }

        it 'passed' do
          expect(htmlable).to be_valid
        end
      end

      context 'when invalid' do
        before { htmlable.body = '<p>1</p>' }

        it 'failed' do
          expect(htmlable).to_not be_valid
        end

        it 'have error message' do
          htmlable.valid?
          expect(htmlable.errors[:body]).to eq(['is too short (minimum is 5 characters)'])
        end
      end
    end # context '.validate_length_minimum'
    
    context '.validate_length_maximum' do
      context 'when valid' do
        before { htmlable.body = '<p>12345</p>' }

        it 'passed' do
          expect(htmlable).to be_valid
        end
      end

      context 'when invalid' do
        before { htmlable.body = '<p>123456789</p>' }

        it 'failed' do
          expect(htmlable).to_not be_valid
        end

        it 'have error message' do
          htmlable.valid?
          expect(htmlable.errors[:body]).to eq(['is too long (maximum is 8 characters)'])
        end
      end
    end # context '.validate_length_maximum'
  end # context '.validate_length'

  context '.validate_presence' do
    with_model :any_htmlable do
      table { |t| t.text :body }
      model do
        validates :body, html: { presence: true }
      end
    end

    let!(:htmlable) { AnyHtmlable.new }

    context 'when valid' do
      before { htmlable.body = '<p>1</p>' }

      it 'passed' do
        expect(htmlable).to be_valid
      end
    end

    context 'when invalid' do
      before { htmlable.body = '<p></p>' }

      it 'failed' do
        expect(htmlable).to_not be_valid
      end

      it 'have error message' do
        htmlable.valid?
        expect(htmlable.errors[:body]).to eq(["can't be blank"])
      end
    end 
  end # context '.validate_presence'
end
