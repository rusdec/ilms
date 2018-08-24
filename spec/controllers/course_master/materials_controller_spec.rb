require_relative '../controller_helper'

RSpec.describe CourseMaster::MaterialsController, type: :controller do
  let!(:author) { create(:course_master, :with_course_and_lesson) }
  let(:lesson) { author.lessons.last }

  describe 'GET #new' do
    context 'when author of lesson' do
      before do
        sign_in(author)
        get :new, params: { lesson_id: lesson }
      end

      it 'assigns new Material to @material' do
        expect(assigns(:material)).to be_a_new(Material)
      end

      it 'relates assigned @material with lesson' do
        expect(assigns(:material).lesson).to eq(lesson)
      end

      it 'relates assigned @material with author' do
        expect(assigns(:material).author).to eq(author)
      end
    end # context 'when author of lesson'

    context 'when not author of lesson' do
      before do
        sign_in(create(:course_master))
        get :new, params: { lesson_id: lesson }
      end

      it 'redirect to root path' do
        expect(response).to redirect_to(root_path)
      end
    end # context 'when not author of lesson'
  end

  describe 'GET #edit' do
    let(:material) { lesson.materials.last }

    context 'when author of material' do
      before do
        sign_in(author)
        get :edit, params: { id: material }
      end

      it 'assign Material to @material' do
        expect(assigns(:material)).to eq(material)
      end
    end # context 'when author of material'

    context 'when not author of material' do
      before do
        sign_in(create(:course_master))
        get :edit, params: { id: material }
      end

      it 'redirect to root path' do
        expect(response).to redirect_to(root_path)
      end
    end # context 'when not author of material'
  end

  describe 'PATCH #update' do
    let(:material) { lesson.materials.last }
    let(:params) { { id: material } }

    context 'when author of lesson' do
      before { sign_in(author) }

      context 'when json' do
        before { params[:format] = :json }

        context 'with valid data' do
          let(:attributes) { attributes_for(:material) }
          before do
            params[:material] = attributes
            patch :update, params: params
            material.reload
          end

          it 'can update material' do
            attributes.each_key do |field|
              expect(material.send field).to eq(attributes[field])
            end
          end

          it 'return success object' do
            expect(response).to match_json_schema('materials/update/success')
          end
        end

        context 'with invalid data' do
          let(:attributes) { attributes_for(:invalid_material) }
          let!(:old_material) { material }

          before do
            params[:material] = attributes
            patch :update, params: params
          end

          it 'can\'t update material' do
            material.reload
            expect(material).to eq(old_material)
          end

          it 'return error object' do
            expect(response).to match_json_schema('shared/errors')
          end
        end
      end
    end

    context 'when not author of lesson' do
      before { sign_in(create(:course_master)) }

      context 'when json' do
        let(:attributes) { attributes_for(:material) }
        let!(:old_material) { material }
        before do
          params[:format] = :json
          params[:material] = attributes
          patch :update, params: params
        end

        it 'can\'t update material' do
          material.reload
          expect(material).to eq(old_material)
        end

        it 'return error object' do
          expect(response).to match_json_schema('shared/errors')
        end
      end
    end
  end

  describe 'POST #create' do
    context 'when author of lesson' do
      before { sign_in(author) }
      let(:params) { { lesson_id: lesson } }

      context 'when json' do
        before { params[:format] = :json }

        context 'with valid data' do
          before { params[:material] = attributes_for(:material_high_order) }

          it 'can create material' do
            expect{
              post :create, params: params
            }.to change(lesson.materials, :count).by(1)
          end

          it 'material creates with necessary attributes' do
            post :create, params: params
            new_material = lesson.materials.last
            params[:material].each_key do |field|
              expect(new_material.send field).to eq(params[:material][field])
            end
          end

          it 'return success object' do
            post :create, params: params
            expect(response).to match_json_schema('materials/create/success')
          end
        end

        context 'with invalid data' do
          before { params[:material] = attributes_for(:invalid_material) }

          it 'can\'t create material' do
            expect{
              post :create, params: params
            }.to_not change(lesson.materials, :count)
          end

          it 'return error object' do
            post :create, params: params
            expect(response).to match_json_schema('shared/errors')
          end
        end
      end
    end

    context 'when not author of lesson' do
      before { sign_in(create(:course_master)) }
      let(:params) { { lesson_id: lesson, material: attributes_for(:material) } }

      context 'when json' do
        before { params[:format] = :json }

        it 'can\'t create material' do
          expect{
            post :create, params: params
          }.to_not change(lesson.materials, :count)
        end

        it 'return error object' do
          post :create, params: params
          expect(response).to match_json_schema('shared/errors')
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:material) { lesson.materials.last }

    context 'when author of material' do
      before { sign_in(author) }

      context 'when json' do
        let(:params) { { id: material, format: :json } }

        it 'can delete material' do
          expect{
            delete :destroy, params: params
          }.to change(lesson.materials, :count).by(-1)
        end

        it 'return success object' do
          delete :destroy, params: params
          expect(response).to match_json_schema('materials/destroy/success')
        end
      end # context 'when json'
    end # context 'when author of material'

    context 'when not author of material' do
      before { sign_in(create(:course_master)) }

      context 'when json' do
        let(:params) { { id: material, format: :json } }

        it 'can\'t delete material' do
          expect{
            delete :destroy, params: params
          }.to_not change(lesson.materials, :count)
        end

        it 'return error object' do
          delete :destroy, params: params
          expect(response).to match_json_schema('shared/errors')
        end
      end # context 'when json'
    end # context 'when not author of material'
  end
end
