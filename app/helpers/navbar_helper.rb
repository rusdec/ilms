module NavbarHelper
  def navbar_link(params = {})
    params[:additional] ||= {}
    content_tag :li, class: 'nav-item' do
      concat(link_to params[:title], params[:path], params[:additional].merge(class: 'nav-link'))
    end
  end

  def authentication_links(user)
    if user

      navbar_link(title: 'Sign out',
                  path: destroy_user_session_path,
                  additional: { method: 'delete' })
    else
      concat(navbar_link(title: 'Sign up', path: new_user_registration_path))
      concat(navbar_link(title: 'Sign in', path: new_user_session_path))
    end
  end
end
