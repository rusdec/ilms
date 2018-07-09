require_relative '../controller_helper'

RSpec.describe Administrator::UsersController, type: :controller do
  describe 'GET #index' do
    context 'when administrator' do
      before { sign_in(create(:administrator)) }

      it 'all User assigns to @users' do
        get :index
        expect(assigns(:users)).to eq(User.all)
      end
    end

    non_admin_roles.each do |role|
      context "when #{role}" do
        before do
          sign_in(create(role.underscore.to_sym))
          get :index
        end

        it 'redirect to root' do
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end # describe 'GET #index'

  describe 'GET #show' do
    context 'when administrator' do
      let!(:user) { create(:user) }
      before { sign_in(create(:administrator)) }

      it 'user assigns to @user' do
        get :show, params: { id: user }
        expect(assigns(:user)).to eq(user)
      end
    end

    non_admin_roles.each do |role|
      context "when #{role}" do
        before do
          sign_in(create(role.underscore.to_sym))
          get :show, params: { id: create(:user) }
        end

        it 'redirect to root' do
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end # describe 'GET #show'

  describe 'PATCH #update' do
    let(:updating_user) { create(:user) }
    let(:user_type) { updating_user.type }

    context 'when administrator' do
      before { sign_in(create(:administrator)) }

      context 'with valid data' do
        let(:params) do
          { id: updating_user, user: { type: 'CourseMaster' }, format: :json }
        end

        context 'when html' do
          before do
            params.delete(:format)
            patch :update, params: params
            updating_user.reload
          end

          it 'redirect to root' do
            expect(response).to redirect_to(root_path)
          end

          it 'can\'t update user' do
            expect(updating_user.type).to eq(user_type)
          end
        end # context 'when html'

        context 'when json' do
          before do
            patch :update, params: params
            updating_user.reload
          end

          it 'return user object' do
            expect(response).to match_json_schema('users/update/success')
          end

          it 'can update user' do
            expect(updating_user.type).to eq('CourseMaster')
          end
        end # context 'when json'
      end # context 'with valid data'

      context 'with invalid data' do
        let(:params) do
          { id: updating_user, user: { type: '' }, format: :json }
        end

        context 'when html' do
          before do
            params.delete(:format)
            patch :update, params: params
            updating_user.reload
          end

          it 'redirect to root' do
            expect(response).to redirect_to(root_path)
          end

          it 'can\'t update user' do
            expect(updating_user.type).to eq(user_type)
          end
        end # context 'when html'

        context 'when json' do
          before do
            patch :update, params: params
            updating_user.reload
          end

          it 'return error object' do
            expect(response).to match_json_schema('shared/errors')
          end

          it 'can\'t update user' do
            expect(updating_user.type).to eq(user_type)
          end
        end
      end
    end # context 'when administrator'

    non_admin_roles.each do |role|
      context "when #{role}" do
        let(:params) do
          { id: updating_user, user: { type: 'CourseMaster' }, format: :json }
        end
        before { sign_in(create(role.underscore.to_sym)) }

        context 'when html' do
          before do
            params.delete(:format)
            patch :update, params: params
            updating_user.reload
          end

          it 'redirect to root' do
            expect(response).to redirect_to(root_path)
          end

          it 'can\'t update user' do
            expect(updating_user.type).to eq(user_type)
          end
        end

        context 'when json' do
          before do
            patch :update, params: params
            updating_user.reload
          end

          it 'return error object' do
            expect(response).to match_json_schema('shared/errors')
          end

          it 'can\'t update user' do
            expect(updating_user.type).to eq(user_type)
          end
        end
      end
    end
  end # describe 'PATCH #update'
end
