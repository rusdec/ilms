document.addEventListener('turbolinks:load', () => {
  /**
   * Make tab active by current action name
   *  For work:
   *  - add to nav items container element class '.nav-action-name'
   *  - add to each nav item element data attribut data-action-name=%{controller_name}_%{action_name}
   *    Example: data-action-name='users_edit'
   *  - set gon.action_name in controller
   *
   *  Work with bootstrap nav link elelemnts
   *  https://getbootstrap.com/docs/4.1/components/navs/#fill-and-justify
   */
  let navActionName = document.querySelector('.nav-action-name')
  if (!navActionName) return

  let navLink = navActionName.querySelector(
    `.nav-item[data-action-name="${gon.action_name}"] .nav-link`
  )
  if (!navLink) return

  navLink.classList.add('active')
})
