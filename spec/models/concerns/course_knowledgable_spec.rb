require_relative '../models_helper'

RSpec.describe CourseKnowledgable, type: :model do

  context 'validate_percent' do
    let!(:course) do
      build(:course, course_knowledges_attributes: [
        attributes_for(:course_knowledge, knowledge: create(:knowledge), percent: 100)
      ])
    end

    context 'when data is invalid' do
      context 'and one of the attributes marked for destruction' do
        before do
          allow(
            course.course_knowledges.last
          ).to receive(:marked_for_destruction?) { true }
        end

        it 'ignores it percent when validates' do
          course.valid?
          expect(course.errors.full_messages).to eq([
            'Percent of course knowledges must be 100% now 0%'
          ])
        end
      end # context 'and one of the attributes marked for destruction'

      context 'when percent less than 100' do
        before { course.course_knowledges.last.percent = 90 }

        it 'course is not valid' do
          expect(course).to_not be_valid
        end

        it 'adds error' do
          course.valid?
          expect(course.errors.full_messages).to eq([
            'Percent of course knowledges must be 100% now 90%'
          ])
        end
      end # context 'when percent less than 100'

      context 'when percent more than 100' do
        before { course.course_knowledges.last.percent = 110 }

        it 'course is not valid' do
          expect(course).to_not be_valid
        end

        it 'adds error' do
          course.valid?
          expect(course.errors.full_messages).to eq([
            'Percent of course knowledges must be 100% now 110%',
            'Course knowledges percent must be less than or equal to 100'
          ])
        end
      end # context 'when percent more than 100'
    end # context 'when data is invalid'

    context 'when valid data' do
      it 'validates course' do
        expect(course).to be_valid
      end
    end 
  end # context 'validate_percent'

  context 'free_knowledges' do
    it 'returns knowledge that is not contained in the course' do
      knowledges = create_list(:knowledge, 3)
      course = create(:course, course_knowledges_attributes: [
        attributes_for(:course_knowledge, knowledge: create(:knowledge), percent: 50),
        attributes_for(:course_knowledge, knowledge: create(:knowledge), percent: 50)
      ])

      expect(course.free_knowledges).to eq(knowledges)
    end
  end
end
