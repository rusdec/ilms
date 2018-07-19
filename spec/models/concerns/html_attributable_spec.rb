require_relative '../models_helper'

RSpec.configure do |config|
  config.extend WithModel
end

RSpec.describe HtmlAttributable, type: :model do
  with_model :any_htmlable do
    table { |t| t.text :body }
    model do
      include HtmlAttributable
      html_attributes :body
    end
  end

  let!(:object) { AnyHtmlable.new }

  it 'create body_html method' do
    expect(object).to respond_to(:body_html)
  end

  it 'create body_html_empty? method' do
    expect(object).to respond_to(:body_html_empty?)
  end

  context '.body_html' do
    context 'when body is nil' do
      it 'body_html return empty' do
        expect(object.body_html).to be_empty
      end
    end

    context 'when body isn\'t nil' do
      it 'body_html return html safely body' do
        object.body = '<p>any</p>'
        expect(object.body_html).to be_html_safe
      end
    end
  end

  context '.body_html_empty' do
    context 'when body is nil' do
      it 'should return true' do
        object.body = nil
        expect(object).to be_body_html_empty
      end
    end

    context 'when body with empty tag' do
      it 'should return true' do
        object.body = '<p></p>'
        expect(object).to be_body_html_empty
      end
    end

    context 'when body with not empty tags' do
      it 'should return false' do
        object.body = '<p>any</p>'
        expect(object).to_not be_body_html_empty
      end
    end
  end
end
