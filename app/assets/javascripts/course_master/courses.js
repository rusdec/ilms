document.addEventListener('turbolinks:load', () => {
  remoteLinksListener('course')
  formLinksListener('course')
})

document.addEventListener('turbolinks:load', () => {
  let courseEditForm = document.querySelector('form.edit_course')
  if (!courseEditForm) return

  courseEditForm.addEventListener('ajax:success', (ev) => {
    let response = parseAjaxResponse(ev)
    if (response.data.errors) return

    let removeImageCheckbox = document.querySelector('.remove-image')
    let previewImage = document.querySelector('img[name="course_image"]')

    if (response.data.object.image.preview) {
      previewImage.src = response.data.object.image.preview
      previewImage.classList.remove('hidden')
      removeImageCheckbox.classList.remove('hidden')
      removeImageCheckbox.querySelectorAll(
        'input[type="checkbox"]:checked'
      ).forEach((i) => { i.checked = false })
    } else {
      previewImage.src = ''
      previewImage.classList.add('hidden')
      removeImageCheckbox.classList.add('hidden')
      removeImageCheckbox.querySelectorAll(
        'input[type="checkbox"]:checked'
      ).forEach((i) => { i.checked = false })
    }
  })
})
