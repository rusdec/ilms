shared_examples_for 'difficultable' do
  it { should validate_presence_of(:difficulty) }
  it do
    should validate_numericality_of(:difficulty)
      .is_greater_than_or_equal_to(1)  
      .is_less_than_or_equal_to(5)
      .only_integer
  end
end
