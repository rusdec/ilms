require_relative '../controller_helper'

RSpec.describe CourseMaster::HomeController, type: :controller do

  let!(:user) { create(:course_master) }

  describe 'GET #index' do
    let!(:courses) { create_list(:course, 5, author: user) }
    before do
      create_list(:course, 2, author: create(:course_master))
      sign_in(user)
      get :index
    end

    it 'user Course assigns to @courses' do
      expect(assigns(:courses)).to eq(courses)
    end
  end

  non_manage_roles.each do |role|
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
