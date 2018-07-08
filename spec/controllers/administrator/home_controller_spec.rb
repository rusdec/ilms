require_relative '../controller_helper'

RSpec.describe Administrator::HomeController, type: :controller do
  describe 'GET #index' do
    context 'when administrator' do
      before do
        sign_in(create(:administrator))
        get :index
      end
      
      it 'All type of users assign to @users' do
        users = [create(:user), create(:course_master), create(:administrator)]
        expect(assigns(:users)).to eq(User.all)
      end
    end

    context 'when not adminstrator' do
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
    end
  end
end
