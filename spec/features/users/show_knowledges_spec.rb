require_relative '../features_helper'

feature 'Show user knowledges', %q{
  As user
  I can open own profile knowledges page
  so that I can see my progress
} do

  given!(:user) { create(:user).decorate }
  given!(:directions) { create_list(:knowledge_direction, 2) }
  before do
    directions.each do |direction|
      create(:user_knowledge, user: user,
                              knowledge: create(:knowledge, direction: direction))
    end
  end

  context 'when authenticated user' do
    context 'and authenticated user open own user page' do
      before do
        sign_in(create(:user))
        visit user_path(user)
        click_on 'Knowledges'
      end

      scenario 'see directions' do
        expect(page).to have_content('Knowledge direction')
        user.knowledge_directions.each do |direction|
          expect(page).to have_content(direction.name.capitalize)
        end
      end # scenario 'see directions'

      scenario 'see knowledges' do
        user.user_knowledges.each do |user_knowledge|
          expect(page).to have_content(user_knowledge.knowledge.name.capitalize)
          expect(page).to have_content(user_knowledge.level)
        end
      end # scenario 'see knowledges'
    end # scenario 'and authenticated user open own user page'
  end # scenario 'when authenticated user'
end
