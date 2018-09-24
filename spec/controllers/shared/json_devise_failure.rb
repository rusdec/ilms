shared_examples_for 'json_devise_failure' do
  context 'when not authenticated user' do
    it 'return devise error' do
      action
      expect(response).to match_json_schema('shared/devise_errors')
    end
  end # context 'when not authenticated user'
end
