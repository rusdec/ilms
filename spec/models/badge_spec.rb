require_relative 'models_helper'

RSpec.describe Badge, type: :model do
  it_behaves_like 'authorable'

  it 'can attach file' do
    subject.image.attach(
      io: File.open("#{fixture_path}/image.png"),
      filename: 'image.png',
      content_type: 'image/png'
    )
    expect(subject.image).to be_attached
  end

  it { should validate_presence_of(:title) }
  it do
    should validate_length_of(:title)
      .is_at_least(3)
      .is_at_most(20)
  end
end
