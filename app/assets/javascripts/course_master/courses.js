document.addEventListener('turbolinks:load', () => {
  let editCourseForm = document.querySelector('.edit_course')
  if (editCourseForm) {
    editCourseForm.addEventListener('ajax:success', (ev) => {
      let response = parseAjaxResponse(ev)
      if (response.data.errors) {
        showErrors(response.data.errors)
      } else if (response.data.status) {
        showSuccess(response.data.message)
      }
    })
  }
})
