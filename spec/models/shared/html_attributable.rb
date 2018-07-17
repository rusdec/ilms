require_relative '../models_helper'

shared_examples_for 'html_attributable' do |attributes|
  let(:object) { described_class.new }

  context 'html attributes' do
    attributes.each do |attribute|
      it "should have #{attribute}_html" do
        expect(object).to respond_to("#{attribute}_html")
      end
    end
  end
end
