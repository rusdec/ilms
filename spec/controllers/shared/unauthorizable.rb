shared_examples_for 'unauthorizable' do
  it 'redirect to root path' do
    expect(response).to redirect_to(root_path)
  end
end
