shared_examples_for 'authorable' do
  it { should belong_to(:author).with_foreign_key(:user_id).class_name('User') }
end
