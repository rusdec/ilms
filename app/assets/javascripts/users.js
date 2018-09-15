document.addEventListener('turbolinks:load', () => { formLinksListener('user') })

document.addEventListener('turbolinks:load', () => {
  let userEditForm = document.querySelector('form.edit_user')
  if (!userEditForm) return

  userEditForm.addEventListener('ajax:success', (ev) => {
    let response = parseAjaxResponse(ev)
    if (response.data.errors) return

    updateCardAvatar(response.data.object.avatar.preview, response.data.object.initials)
    updateFormAvatar(response.data.object.avatar.preview, response.data.object.initials)
    updateHeaderAvatar(response.data.object.avatar.preview, response.data.object.initials)
    updateCardFullName(response.data.object.full_name)
    updateHeaderFullName(response.data.object.full_name)
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

function updateHeaderFullName(full_name) {
  let fullNameHeader = document.querySelector('.fullname-header')
  if (!fullNameHeader) return

  fullNameHeader.innerText = full_name
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
  if (!formAvatar) return 

  let removeAvatarFormGroup = document.querySelector('form .remove-avatar')

  updateAvatar(formAvatar, avatarUrl, initials)

  if (avatarUrl) {
    formAvatar.classList.remove('opacity-05')
    removeAvatarFormGroup.classList.remove('hidden')
  } else {
    formAvatar.classList.add('opacity-05')
    removeAvatarFormGroup.classList.add('hidden')
  }
}

function updateHeaderAvatar(avatarUrl, initials) {
  let headerAvatar = document.querySelector('.avatar-header')
  if (!headerAvatar) return 

  updateAvatar(headerAvatar, avatarUrl, initials)
}

function updateCardAvatar(avatarUrl, initials) {
  let cardAvatar = document.querySelector('.card-profile .card-profile-avatar')
  if (!cardAvatar) return

  updateAvatar(cardAvatar, avatarUrl, initials)
}

function updateAvatar(avatar, avatarUrl, initials) {
  /**
   * Avatar with user initials
   */
  if (!avatarUrl) {
    avatar.style.backgroundImage = ''
    avatar.innerText = initials
    return
  }

  /**
   * Avatar with image
   */
  if (avatarUrl) {
    avatar.innerText = ''
    avatar.style.backgroundImage = `url('${avatarUrl}')`
    return
  }
}
