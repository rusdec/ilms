document.addEventListener('turbolinks:load', () => { formLinksListener('user') })

document.addEventListener('turbolinks:load', () => {
  let userEditForm = document.querySelector('form.edit_user')
  if (!userEditForm) return

  userEditForm.addEventListener('ajax:success', (ev) => {
    let response = parseAjaxResponse(ev)
    if (response.data.errors) return

    updateCardAvatar(response.data.object.avatar.preview, response.data.object.initials)
    updateFormAvatar(response.data.object.avatar.preview, response.data.object.initials)
    updateCardFullName(response.data.object.full_name)
    updateCardEmail(response.data.object.email)
    clearPasswordFields()
    unckeckCheckedCkeckboxes()
  })
})

function unckeckCheckedCkeckboxes() {
  document.querySelectorAll('input[type="checkbox"]:checked').forEach((c) => c.checked = false)
}

function clearPasswordFields() {
  [
    '#user_current_password',
    '#user_password',
    '#user_password_confirmation'
  ].forEach((selector) => {
    let field = document.querySelector(selector)
    if (!field) return
    field.value = ''
  })
}

function updateCardFullName(full_name) {
  let cardFullName = document.querySelector('.card-profile .card-full-name')
  if (!cardFullName) return
  cardFullName.innerText = full_name
}

function updateCardEmail(email) {
  let cardEmail = document.querySelector('.card-profile .card-email')
  if (!cardEmail) return
  cardEmail.innerText = email
}

function updateFormAvatar(avatarUrl, initials) {
  let formAvatar = document.querySelector('form .avatar')
  let removeAvatarFormGroup = document.querySelector('form .remove-avatar')
  if (!formAvatar) return 

  if (avatarUrl) {
    formAvatar.style.backgroundImage = `url(${avatarUrl})`
    formAvatar.innerText = ''
    formAvatar.classList.remove('opacity-05')
    removeAvatarFormGroup.classList.remove('hidden')
  } else {
    formAvatar.style.backgroundImage = ''
    formAvatar.innerText = initials
    formAvatar.classList.add('opacity-05')
    removeAvatarFormGroup.classList.add('hidden')
  }
}

function updateCardAvatar(avatarUrl, initials) {
  let cardAvatar = document.querySelector('.card-profile .card-profile-avatar')
  if (!cardAvatar) return

  /**
   * Avatar with user initials
   */
  if (!avatarUrl) {
    cardAvatar.style.backgroundImage = ''
    cardAvatar.innerText = initials
    return
  }

  /**
   * Avatar with image
   */
  if (avatarUrl) {
    cardAvatar.innerText = ''
    cardAvatar.style.backgroundImage = `url('${avatarUrl}')`
    return
  }
}
