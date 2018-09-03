 require_relative 'controller_helper'

RSpec.describe UsersController, type: :controller do
  describe 'PATCH #update' do
    let!(:user) { create(:user) }
    let(:avatar) { Rack::Test::UploadedFile.new("#{fixture_path}/image.png") }
    let(:attributes) { attributes_for(:user, avatar: avatar) }
    let(:params) { { id: user, user: attributes } }

    context 'when json' do
      before { params[:format] = :json }

      context 'when authenticated user' do
        before { sign_in(user) }

        context 'and user updates himself' do
          context 'and data is valid' do
            context 'and not updates password' do
              before { params[:user][:password] = nil }

              it_behaves_like 'able_to_update_a_user'
            end # context 'and not updates password'

            context 'and updates password' do
              before do
                params[:user][:current_password] = attributes[:password]
                params[:user][:password] = 'new_password'
                params[:user][:password_confirmation] = 'new_password'
              end

              it_behaves_like 'able_to_update_a_user'
            end # context 'and updates password'
          end #context 'and data is valid'

          context 'and data is not valid' do
            before { params[:user] = attributes_for(:user, :invalid) }

            it_behaves_like 'failure_to_update_a_user' do
              let(:original_name) { user.name }
              let(:original_surname) { user.surname }
              let(:original_email) { user.email }
              let(:json_error_schema) { 'shared/errors' }
            end
          end # context 'and data is not valid'
        end # context 'and user update self'

        context 'and user updates foreign user' do
          before { sign_in(create(:user)) }

          it_behaves_like 'failure_to_update_a_user' do
            let(:original_name) { user.name }
            let(:original_surname) { user.surname }
            let(:original_email) { user.email }
            let(:json_error_schema) { 'shared/errors' }
          end
        end #context 'and user updates foreign user'
      end # context 'when authenticated user' do

      context 'when not uathenticated user' do
        it_behaves_like 'failure_to_update_a_user' do
          let(:original_name) { user.name }
          let(:original_surname) { user.surname }
          let(:original_email) { user.email }
          let(:json_error_schema) { 'shared/devise_errors' }
        end
      end #context 'when not uathenticated user'
    end # context 'when json'
  end

  describe 'GET #show' do
    let!(:user) { create(:user) }
    let(:action) { get :show, params: { id: user.id } }

    context 'when authenticated user' do
      context 'and authenticated user open own user page' do
        before do
          sign_in(user)
          action
        end

        it 'assigns User to @user' do
          expect(assigns(:user)).to eq(user)
        end

        it 'decorates assigned user' do
          expect(assigns(:user)).to be_decorated
        end

        it 'responses 200 OK' do
          expect(response).to be_ok
        end
      end # context 'and authenticated user open own user page'

      context 'and authenticated user open foreign user page' do
        before do
          sign_in(create(:user))
          action
        end

        it 'assigns User to @user' do
          expect(assigns(:user)).to eq(user)
        end

        it 'decorates assigned user' do
          expect(assigns(:user)).to be_decorated
        end

        it 'responses 200 OK' do
          expect(response).to be_ok
        end
      end # context 'and authenticated user open own user page'
    end # context 'when authenticated user'

    context 'when not authenticated user' do
      before { action }

      it 'redirect to root' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end # context 'when not authenticated user'
  end
end
