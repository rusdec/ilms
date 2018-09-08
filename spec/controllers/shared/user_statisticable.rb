shared_examples_for 'user_statisticable' do
  let!(:user) { create(:user) }

  describe 'GET #courses_progress' do
    let!(:signing_user) { create(:user) }
    let(:action) { get :courses_progress, params: { user: user } }

    context 'when json' do
      before { action[:params][:format] = :json }

      context 'when authenticated user' do
        before { sign_in(signing_user) }

        it 'returns course_progress object' do
          expect(response).to match_json_schema('user_statistics/courses_progress/access')
        end
      end # context 'when authenticated user'

      context 'when not authenticated user' do
      end # context 'when not authenticated user'
    end # context 'when json'
  end

  describe 'GET #lessons_progress' do
    let!(:signing_user) { create(:user) }
    let(:action) { get :lessons_progress, params: { user: user } }

    context 'when json' do
      context 'when authenticated user' do
      end # context 'when authenticated user'

      context 'when not authenticated user' do
      end # context 'when not authenticated user'
    end # context 'when json'
  end

  describe 'GET #quests_progress' do
    let!(:signing_user) { create(:user) }
    let(:action) { get :quests_progress, params: { user: user } }

    context 'when json' do
      context 'when authenticated user' do
      end # context 'when authenticated user'

      context 'when not authenticated user' do
      end # context 'when not authenticated user'
    end # context 'when json'
  end

  describe 'GET #badges_progress' do
    let!(:signing_user) { create(:user) }
    let(:action) { get :badges_progress, params: { user: user } }

    context 'when json' do
      context 'when authenticated user' do
      end # context 'when authenticated user'

      context 'when not authenticated user' do
      end # context 'when not authenticated user'
    end # context 'when json'
  end

  describe 'GET #top_three_knowledges' do
    let!(:signing_user) { create(:user) }
    let(:action) { get :top_three_knowledges, params: { user: user } }

    context 'when json' do
      context 'when authenticated user' do
      end # context 'when authenticated user'

      context 'when not authenticated user' do
      end # context 'when not authenticated user'
    end # context 'when json'
  end

  describe 'GET #knowledges_directions' do
    let!(:signing_user) { create(:user) }
    let(:action) { get :knowledges_directions, params: { user: user } }

    context 'when json' do
      context 'when authenticated user' do
      end # context 'when authenticated user'

      context 'when not authenticated user' do
      end # context 'when not authenticated user'
    end # context 'when json'
  end
end
