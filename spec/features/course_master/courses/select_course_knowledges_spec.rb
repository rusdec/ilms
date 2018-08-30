require_relative '../../features_helper'

feature 'Select course knowledges', %q{
  As author of course
  I can select knowledges for course
  so that user see them and can improve them
} do

  let!(:knowledge_one) { create(:knowledge) }
  let!(:knowledge_two) { create(:knowledge) }
  let!(:course) { attributes_for(:course) }

  before do
    sign_in(create(:course_master))
    visit course_master_courses_path
    click_on 'Create your course'
    within 'form' do
      fill_in 'Title', with: course[:title]
      fill_editor 'Decoration description', with: course[:decoration_description]
    end
  end

  scenario 'can change percents', js: true do
    within 'form' do
      expect(page).to have_content('0% EXP')

      select_knowledge(knowledge_one.name)
      expect(page).to have_content('1% EXP')

      set_percent_for_knowledge(knowledge_one.name, 20)
      expect(page).to have_content('20% EXP')

      cancel_knowledge(knowledge_one.name)
      expect(page).to have_content('0% EXP')

      select_knowledge(knowledge_one.name)
      set_percent_for_knowledge(knowledge_one.name, 50)
      select_knowledge(knowledge_two.name)
      set_percent_for_knowledge(knowledge_two.name, 50, 1)
      expect(page).to have_content('100% EXP')

      set_percent_for_knowledge(knowledge_two.name, 150, 1)
      expect(page).to have_content('100% EXP')

      set_percent_for_knowledge(knowledge_two.name, -150, 1)
      expect(page).to have_content('100% EXP')
    end
  end # scenario 'can change percents'

  context 'when percent is 100', js: true do
    scenario 'can\'t move knowledge from list to table' do
      select_knowledge(knowledge_one.name)
      set_percent_for_knowledge(knowledge_one.name, 100)

      select_knowledge(knowledge_two.name)
      select_custom_knowledge('Myknowledge')
      within selected_knowledges do
        expect(page).to_not have_content(knowledge_two.name.capitalize)
        expect(page).to_not have_content('Myknowledge')
      end
      within free_knowledges do
        expect(page).to have_content(knowledge_two.name.capitalize)
      end

    end
  end

  context 'when percent is less than 100', js: true do
    scenario 'can move knowledge from list to table' do
      [knowledge_one, knowledge_two].each_with_index do |knowledge, i|
        select_knowledge(knowledge.name)
        set_percent_for_knowledge(knowledge.name, 30, i)
        within selected_knowledges do
          expect(page).to have_content(knowledge.name.capitalize)
        end
        within free_knowledges do
          expect(page).to_not have_content(knowledge.name.capitalize)
        end
      end
    end
  end

  scenario 'can cancel selected knowledge', js: true do
    select_knowledge(knowledge_one.name)
    set_percent_for_knowledge(knowledge_one.name, 30)
    within selected_knowledges do
      expect(page).to have_content(knowledge_one.name.capitalize)
    end
    within free_knowledges do
      expect(page).to_not have_content(knowledge_one.name.capitalize)
    end

    cancel_knowledge(knowledge_one.name)
    within selected_knowledges do
      expect(page).to_not have_content(knowledge_one.name.capitalize)
    end
    within free_knowledges do
      expect(page).to have_content(knowledge_one.name.capitalize)
    end
    expect(page).to_not have_content('30% EXP')
    expect(page).to have_content('0% EXP')
  end

  scenario 'can add custom knowledge', js: true do
    name = 'my_knowledge'

    select_custom_knowledge(name)
    within selected_knowledges do
      expect(page).to have_content(name.capitalize)
    end
    within free_knowledges do
      expect(page).to_not have_content(name.capitalize)
    end
    expect(page).to have_content('1% EXP')

    cancel_knowledge(name)
    within selected_knowledges do
      expect(page).to_not have_content(name.capitalize)
    end
    within free_knowledges do
      expect(page).to_not have_content(name.capitalize)
    end
    expect(page).to have_content('0% EXP')
  end

  context 'when course is created' do
    before do
      select_knowledge(knowledge_one.name)
      set_percent_for_knowledge(knowledge_one.name, 50)
      select_knowledge(knowledge_two.name)
      set_percent_for_knowledge(knowledge_two.name, 50, 1)
      click_on 'Create Course'
    end

    context 'when total percent is 100' do
      scenario 'can delete knowledge from course', js: true do
        within selected_knowledges do
          expect(page).to have_content(knowledge_one.name.capitalize)
          expect(page).to have_content(knowledge_two.name.capitalize)
        end

        within free_knowledges do
          expect(page).to_not have_content(knowledge_one.name.capitalize)
          expect(page).to_not have_content(knowledge_two.name.capitalize)
        end
        
        mark_for_delete(knowledge_one.name, 0)
        set_percent_for_knowledge(knowledge_two.name, 100, 1)
        click_on 'Update Course'

        within selected_knowledges do
          expect(page).to_not have_content(knowledge_one.name.capitalize)
          expect(page).to have_content(knowledge_two.name.capitalize)
        end

        within free_knowledges do
          expect(page).to have_content(knowledge_one.name.capitalize)
          expect(page).to_not have_content(knowledge_two.name.capitalize)
        end
      end
    end # context 'when total percen is 100'

    context 'when total percent is less than 100' do
      scenario 'can\'t delete knowledge from course', js: true do
        mark_for_delete(knowledge_one.name, 0)
        click_on 'Update Course'

        expect(page).to have_content('Percent of course knowledges must be 100% now 50%')

        within selected_knowledges do
          expect(page).to have_content(knowledge_one.name.capitalize)
          expect(page).to have_content(knowledge_two.name.capitalize)
        end

        within free_knowledges do
          expect(page).to_not have_content(knowledge_one.name.capitalize)
          expect(page).to_not have_content(knowledge_two.name.capitalize)
        end
      end
    end # context 'when total percent is less than 100'
  end
end
