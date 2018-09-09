shared_examples_for 'user_statisticable' do
  let!(:statistic_user) { create(:user) }

  describe 'GET #courses_progress' do
    let!(:signing_user) { create(:user) }
    let(:params) { { user_id: statistic_user } }
    let(:action) { get :courses_progress, params: params }
    before do
      create_list(:course_passage, 2, user: statistic_user, status: Status.passed)
      create(:course_passage, user: statistic_user, status: Status.in_progress)
    end

    context 'when json' do
      before { params[:format] = :json }

      context 'when authenticated user' do
        before do
          sign_in(signing_user)
          action
        end

        it 'returns course_progress object' do
          expect(response).to match_json_schema('user_statistics/courses_progress/access')
        end
      end # context 'when authenticated user'

      it_behaves_like 'json_devise_failure'
    end # context 'when json'
  end

  describe 'GET #lessons_progress' do
    let!(:signing_user) { create(:user) }
    let(:params) { { user_id: statistic_user } }
    let(:action) { get :lessons_progress, params: params }
    before do
      create_list(:lesson_passage, 2, user: statistic_user).each(&:passed!)
      create(:lesson_passage, user: statistic_user)
    end

    context 'when json' do
      before { params[:format] = :json }

      context 'when authenticated user' do
        before do
          sign_in(signing_user)
          action
        end

        it 'returns lessons_progress object' do
          expect(response).to match_json_schema('user_statistics/lessons_progress/access')
        end
      end # context 'when authenticated user'

      it_behaves_like 'json_devise_failure'
    end # context 'when json'
  end

  describe 'GET #quests_progress' do
    let!(:signing_user) { create(:user) }
    let(:params) { { user_id: statistic_user } }
    let(:action) { get :quests_progress, params: params }
    before do
      create_list(:quest_passage, 2, user: statistic_user).each(&:passed!)
      create(:quest_passage, user: statistic_user)
    end

    context 'when json' do
      before { params[:format] = :json }

      context 'when authenticated user' do
        before do
          sign_in(signing_user)
          action
        end

        it 'returns quests_progress object' do
          expect(response).to match_json_schema('user_statistics/quests_progress/access')
        end
      end # context 'when authenticated user'

      it_behaves_like 'json_devise_failure'
    end # context 'when json'
  end

  describe 'GET #badges_progress' do
    let!(:signing_user) { create(:user) }
    let(:params) { { user_id: statistic_user } }
    let(:action) { get :badges_progress, params: params }
    before do
      course = create(:course)
      create_list(:course, 2).collect do |course|
        badge = create(:badge, course: course, badgable: course)
        create(:course_passage, passable: course, user: statistic_user).passed!
        statistic_user.reward!(badge)
      end
    end

    context 'when json' do
      before { params[:format] = :json }

      context 'when authenticated user' do
        before do
          sign_in(signing_user)
          action
        end

        it 'returns badges_progress object' do
          expect(response).to match_json_schema('user_statistics/badges_progress/access')
        end
      end # context 'when authenticated user'

      it_behaves_like 'json_devise_failure'
    end # context 'when json'
  end

  describe 'GET #top_three_knowledges' do
    let!(:signing_user) { create(:user) }
    let(:params) { { user_id: statistic_user } }
    let(:action) { get :top_three_knowledges, params: params }

    context 'when json' do
      before { params[:format] = :json }

      context 'when authenticated user' do
        before do
          sign_in(signing_user)
          action
        end

        it 'returns top_three_knowledges object' do
          expect(response).to match_json_schema('user_statistics/top_three_knowledges/access')
        end
      end # context 'when authenticated user'

      it_behaves_like 'json_devise_failure'
    end # context 'when json'
  end

  describe 'GET #knowledges_directions' do
    let!(:signing_user) { create(:user) }
    let(:params) { { user_id: statistic_user } }
    let(:action) { get :knowledges_directions, params: params }
    before do
      user_knowledges = create_list(:user_knowledge, 2, user: statistic_user)
      user_knowledge = create(:user_knowledge,
        user: statistic_user,
        knowledge: create(:knowledge, direction: user_knowledges[0].knowledge.direction)
      )
    end

    context 'when json' do
      before { params[:format] = :json }

      context 'when authenticated user' do
        before do
          sign_in(signing_user)
          action
        end

        it 'returns knowledges_directions object' do
          expect(response).to match_json_schema('user_statistics/knowledges_directions/access')
        end
      end # context 'when authenticated user'

      it_behaves_like 'json_devise_failure'
    end # context 'when json'
  end
end
