module Administrator::UsersHelper
  def editable_role(user)
    content_tag :span, class: 'editing-container' do
      concat(non_editing_part(user))
      concat(editing_part(user))
    end
  end

  def non_editing_part(user)
    type = tag.span t("roles.#{user.type.underscore}")
    link = link_to t('actions.edit'), 'javascript:void(0)'
    tag.span "#{type} #{link}".html_safe, class: 'non-editing'
  end

  def editing_part(user)
    form_with url: administrator_user_path(user),
              method: :patch,
              class: 'inline_edit hidden',
              remote: true, format: :json do |f|
      concat(
        f.select 'user[type]',
        options_for_select(
          Role.all.map { |role| [t("roles.#{role.underscore}"), role] }, selected: user.type
        )
      )
      concat(f.submit t('actions.save'))
      concat(link_to t('actions.cancel'), 'javascript:void(0)')
    end
  end
end
