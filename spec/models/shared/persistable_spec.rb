shared_examples_for 'persistable' do |collection|
  before { collection.new }

  it '#persistable' do
    expect(collection.persisted).to eq(collection.where.not(id: nil))
  end
end
