require_relative '../controller_helper'

RSpec.describe CourseMaster::BadgesController, type: :controller do
  with_model :any_badgable do
    table do |t|
      t.references :user
      t.integer :course_id
    end

    model do
      include Rewardable
      include Authorable

      belongs_to :course
    end
  end

  controller do
    def set_breadcrumb_chain_any_badgable(x)
    end
  end

  before do
    routes.draw do
      concern :badgable do
        resources :badges, only: %i(create new)
      end

      namespace :course_master do
        resources :badges, except: %i(create new)
        resources :any_badgables do
          concerns :badgable
        end
      end
    end
  end

  context 'GET #index' do
    let(:action) { get :index }
    let!(:user) { create(:course_master) }

    context 'when authenticated user' do
      context 'when user is CourseMaster' do
        let!(:user) { create(:course_master) }
        before do
          sign_in(user)
          3.times { create(:badge, author: user) }
          create(:badge, author: create(:course_master))
          action
        end

        it 'assigned badges related with user to @badges' do
          expect(assigns(:badges)).to eq(user.created_badges)
        end

        it 'assigns @badges are decorateds' do
          expect(assigns(:badges)).to be_decorated
        end
      end

      context 'when user is User' do
        before do
          sign_in(create(:user))
          action
        end

        it_behaves_like 'unauthorizable'
      end
    end # context 'when authenticated user'

    context 'when not authenticated user' do
      before { action }
      it_behaves_like 'unauthorizable'
    end
  end

  context 'GET #new' do
    let!(:user) { create(:course_master) }
    let(:badgable) { AnyBadgable.create(author: user, course: create(:course, author: user)) }
    let(:action) do
      get :new, params: { any_badgable_id: badgable }
    end

    context 'when authenticated user' do
      context 'when user is CourseMaster' do
        before do
          sign_in(user)
          action
        end

        it 'assigns new Badge to @badge' do
          expect(assigns(:badge)).to be_a_new(Badge)
        end

        it 'assigns @badges are decorateds' do
          expect(assigns(:badge)).to be_decorated
        end

        it 'assigned @badge related with user' do
          expect(assigns(:badge).author).to eq(user)
        end

        it 'assigned @badge related with course' do
          expect(assigns(:badge).course).to eq(badgable.course)
        end

        it 'assigned @badge related with badgable' do
          expect(assigns(:badge).badgable).to eq(badgable)
        end
      end # context 'when user is CourseMaster'

      context 'when user is User' do
        before do
          sign_in(create(:user))
          action
        end

        it_behaves_like 'unauthorizable'
      end # context 'when user is User'
    end # context 'when authenticated user'

    context 'when not authenticated user' do
      before { action }
      it_behaves_like 'unauthorizable'
    end
  end

  describe 'POST #create' do
    let(:user) { create(:course_master) }
    let!(:badgable) { AnyBadgable.create(author: user, course: create(:course, author: user)) }
    let(:params) { { any_badgable_id: badgable, badge: attributes_for(:badge) } }
    let(:action) { post :create, params: params }

    context 'when authenticated user' do
      context 'when user is CourseMaster' do
        context 'when json' do
          before { params[:format] = :json }

          context 'when user is author of badgable' do
            before { sign_in(user) }

            context 'when data is valid' do
              it 'creates badge related with user' do
                expect{ action }.to change(user.created_badges, :count).by(1)
              end

              it 'creates badge related with user' do
                expect{ action }.to change(badgable.course.badges, :count).by(1)
              end

              it 'return success' do
                action
                expect(response).to match_json_schema('badges/create/success')
              end
            end # context 'when data is valid'

            context 'when data is invalid' do
              before { params[:badge] = attributes_for(:invalid_badge) }

              it 'not creates badge' do
                expect{ action }.to_not change(Badge, :count)
              end

              before { action }
              it_behaves_like 'recipient_of_json_with_errors'
            end # context 'when data is invalid'
          end # context 'when user is author of badgable'

          context 'when user is not author of badgable' do
            before do
              sign_in(create(:course_master))
              action
            end
            it_behaves_like 'recipient_of_json_with_errors'
          end
        end # context 'when json'
      end # context 'when user is CourseMaster'

      context 'when user is User' do
        before { sign_in(create(:user)) }

        it 'not creates badge' do
          expect{ action }.to_not change(Badge, :count)
        end

        before { action }
        it_behaves_like 'unauthorizable'
      end
    end # context 'when authenticated user'

    context 'when not authenticated user' do
      before { action }
      it_behaves_like 'unauthorizable'
    end
  end

  context 'GET #edit' do
    let!(:user) { create(:course_master) }
    let!(:badge) { create(:badge, author: user) }
    let(:action) { get :edit, params: { id: badge } }

    context 'when authenticated user' do
      context 'when author of badge' do
        before { sign_in(user) }

        it 'assigns finded badge to @badge' do
          action
          expect(assigns(:badge)).to eq(badge)
        end
      end # context 'when author of badge'

      context 'when not author of badge' do
        before do
          sign_in(create(:course_master))
          action
        end

        it_behaves_like 'unauthorizable'
      end
    end # context 'when authenticated user'

    context 'when not authenticated user' do
      before { action }
      it_behaves_like 'unauthorizable'
    end
  end

  context 'PATCH #update' do
    let(:user) { create(:course_master) }
    let(:badge) { create(:badge, author: user) }
    let(:params) { { id: badge.id, badge: { title: 'NewTitle' } } }
    let(:action) { patch :update, params: params }

    context 'when json' do
      before { params[:format] = :json }

      context 'when authenticated user' do
        context 'when user is author of badge' do
          before { sign_in(user) }

          context 'when data is valid' do
            it 'updates badge' do
              action
              expect(assigns(:badge).title).to eq(params[:badge][:title])
            end

            it 'return success' do
              action
              expect(response).to match_json_schema('badges/update/success')
            end
          end # context 'when data is valid'

          context 'when data is not valid' do
            before { params[:badge] = attributes_for(:invalid_badge) }
          end # context 'when data is not valid'
        end # context 'when user is author of badge'

        context 'when user is not author of badge' do
          before do
            sign_in(create(:course_master))
            action
          end

          it 'not updates badge' do
            expect(assigns(:badge)).to eq(badge)
          end

          it_behaves_like 'recipient_of_json_with_errors'
        end # context 'when user is not author of badge'
      end # context 'when authenticated user'

      context 'when not authenticated user' do
        before { action }

        it_behaves_like 'recipient_of_json_with_errors'
      end
    end # context 'when json'
  end

  context 'DELETE #destroy' do
    let!(:user) { create(:course_master) }
    let!(:badge) { create(:badge, author: user) }
    let(:params) { { id: badge } }
    let(:action) { delete :destroy, params: params }

    context 'when json' do
      before { params[:format] = :json }

      context 'when authenticated user' do
        context 'when user is author of badge' do
          before { sign_in(user) }

          it 'deletes badge' do
            expect{ action }.to change(user.created_badges, :count).by(-1)
          end

          it 'return success' do
            action
            expect(response).to match_json_schema('badges/destroy/success')
          end
        end # context 'when user is author of badge'

        context 'when user is not author of badge' do
          before do
            sign_in(create(:course_master))
            action
          end

          it 'not deletes badge' do
            expect{ action }.to_not change(Badge, :count)
          end

          it_behaves_like 'recipient_of_json_with_errors'
        end # context 'when user is not author of badge'
      end # context 'when authenticated user'

      context 'when not authenticated user' do
        before { action }

        it 'not deletes badge' do
          expect{ action }.to_not change(Badge, :count)
        end

        it_behaves_like 'recipient_of_json_with_errors'
      end
    end # context 'when json'
  end
end
