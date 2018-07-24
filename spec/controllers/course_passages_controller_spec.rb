require_relative 'controller_helper'

RSpec.describe CoursePassagesController, type: :controller do
  let(:user) { create(:course_master, :with_course_and_lessons) }
  let!(:course_passage) do
    create(:course_passage, educable: user, course: user.courses.last)
  end

  describe 'GET #index' do
    context 'when authenticated user' do
      before do
        sign_in(user)
        get :index
      end

      it 'assign users CoursePassage to @course_passages' do
        expect(assigns(:course_passages)).to eq(user.course_passages)
      end
    end

    context 'when not authenticated user' do
      before { get :index }

      it 'redirect to root' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #show' do
    let(:params) { { id: course_passage.id } }

    context 'when authenticated user' do
      context 'when owner of course_passage' do
        before do
          sign_in(user)
          get :show, params: params
        end

        it 'assign course_passage.lesson_passages to @lesson_passages' do
          expect(assigns(:lesson_passages)).to eq(course_passage.lesson_passages)
        end
      end

      context 'when not owner of course_passage' do
        before do
          sign_in(create(:user))
          get :show, params: params
        end

        it 'redirect to root path' do
          expect(response).to redirect_to(root_path)
        end
      end
    end # context 'when authenticated user'

    context 'when not authenticated user' do
      before { get :show, params: params }
    end
  end

  describe 'POST #create' do
    let(:course) { create(:course, author: user) }

    context 'when authenticated user' do
      before { sign_in(user) }

      context 'when json' do
        let(:params) { { format: :json } }

        context 'when valid data' do
          before { params[:course_passage] = { course_id: course } }

          it 'create course_passage' do
            expect{
              post :create, params: params
            }.to change(user.course_passages, :count).by(1)
          end

          it 'return success object' do
            post :create, params: params
            expect(response).to match_json_schema('shared/success_with_location')
          end
        end # context 'when valid data'

        context 'when invalid data' do
          before { params[:course_passage] = { course_id: nil } }

          it 'return error object' do
            post :create, params: params
            expect(response).to match_json_schema('shared/errors')
          end
        end
      end # context 'when json'
    end # context 'when authenticated user'

    context 'when not authenticated user' do
      before do
        post :create, params: { course_passage: { course_id: course }, format: :json }
      end

      it 'return devise error object' do
        expect(response).to match_json_schema('shared/devise_errors')
      end
    end
  end
end
