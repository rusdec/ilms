document.addEventListener('turbolinks:load', () => {
  remoteLinksListener('badge')
  formLinksListener('badge')
})

document.addEventListener('turbolinks:load', () => {
  let badgeEditForm = document.querySelector('form.edit_badge')
  if (!badgeEditForm) return

  badgeEditForm.addEventListener('ajax:success', (ev) => {
    let response = parseAjaxResponse(ev)
    if (response.data.errors) return
    if (!response.data.object.image.preview) return

    document.querySelector('img[name="badge_image"]').src = response.data.object.image.preview
  })
})
