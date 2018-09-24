shared_examples_for 'statusable' do
  it { should belong_to(:status) }
end
