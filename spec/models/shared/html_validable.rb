shared_examples_for 'html_length_minimum_validable' do
  it 'when less than minimum should be invalid' do
    text = 'x' * (html_validable[:minimum] - 1)
    html_validable[:object].send "#{html_validable[:field]}=", "<span>#{text}</span>"
    expect(html_validable[:object]).to_not be_valid
  end

  it 'when equal minimum should be valid' do
    text = 'x' * html_validable[:minimum]
    html_validable[:object].send "#{html_validable[:field]}=", "<span>#{text}</span>"
    expect(html_validable[:object]).to be_valid
  end
end

shared_examples_for 'html_length_maximum_validable' do
  it 'when most maximum than should be invalid' do
    text = 'x' * (html_validable[:maximum] + 1)
    html_validable[:object].send "#{html_validable[:field]}=", "<span>#{text}</span>"
    expect(html_validable[:object]).to_not be_valid
  end

  it 'when equal maximum should be valid' do
    text = 'x' * html_validable[:maximum]
    html_validable[:object].send "#{html_validable[:field]}=", "<span>#{text}</span>"
    expect(html_validable[:object]).to be_valid
  end
end

shared_examples_for 'html_presence_validable' do
  it 'when spaces only should be invalid' do
    text = '<span>                                                          </span>'
    html_validable[:object].send "#{html_validable[:field]}=", text
    expect(html_validable[:object]).to_not be_valid
  end
end
