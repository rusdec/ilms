require_relative '../controller_helper'

RSpec.describe CourseMaster::KnowledgeDirectionsController, type: :controller do
  describe 'POST #create' do
    let(:params) { { knowledge_direction: attributes_for(:knowledge_direction) } }

    context 'when authenticated user' do
      before { sign_in(create(:course_master)) }

      context 'when json' do
        before { params[:format] = :json }

        context 'and data is valid' do
          it 'creates knowledge direction' do
            expect{
              post :create, params: params
            }.to change(KnowledgeDirection, :count).by(1)
          end

          it 'returns object' do
            post :create, params: params
            expect(response).to match_json_schema('knowledge_directions/create/success')
          end
        end

        context 'and data is invalid' do
          before do
            params[:knowledge_direction] = attributes_for(:knowledge_direction, :invalid)
          end

          it 'not creates knowledge direction' do
            expect{
              post :create, params: params
            }.to_not change(KnowledgeDirection, :count)
          end

          it 'returns error' do
            post :create, params: params
            expect(response).to match_json_schema('shared/errors')
          end
        end
      end
    end

    context 'when not authenticated user' do
      context 'when json' do
        before { params[:format] = :json }

        it 'returns error' do
          post :create, params: params
          expect(response).to match_json_schema('shared/devise_errors')
        end
      end
    end
  end
end
