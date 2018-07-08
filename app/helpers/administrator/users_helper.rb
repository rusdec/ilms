module Administrator::UsersHelper
  def editable_role(user)
    content_tag :span, class: 'editing-container' do
      concat(non_editing_part(user))
      concat(editing_part(user))
    end
  end

  def non_editing_part(user)
    type = tag.span user.type
    link = link_to 'Edit', 'javascript:void(0)'
    tag.span "#{type} #{link}".html_safe, class: 'non-editing'
  end

  def editing_part(user)
    form_with url: administrator_user_path(user),
              method: :patch,
              class: 'inline_edit hidden',
              remote: true, format: :json do |f|
      concat(f.select 'user[type]', options_for_select(Role.all, selected: user.type))
      concat(f.submit 'Save')
      concat(link_to 'Cancel', 'javascript:void(0)')
    end
  end
end
