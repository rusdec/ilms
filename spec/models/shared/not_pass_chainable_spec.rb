shared_examples_for 'not_pass_chainable' do
  it 'passage should not receive passed!' do
    expect(passage).to_not receive(:passed!)
    passage.try_chain_pass!
  end

  it 'passage should not receive after_pass_hook' do
    expect(passage).to_not receive(:after_pass_hook)
    passage.try_chain_pass!
  end

  it 'parent should not receive try_chain_pass!' do
    expect(passage.parent).to_not receive(:try_chain_pass!)
    passage.try_chain_pass!
  end
end
