shared_examples_for 'html_attributable' do |attributes|
  attributes.each do |attribute|
    it "should have #{attribute}_html" do
      expect(described_class.new).to respond_to("#{attribute}_html")
    end
  end
end
