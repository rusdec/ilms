/**
 * Edit
 */
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

/**
 * New
 */
document.addEventListener('turbolinks:load', () => {
  let editCourseForm = document.querySelector('.new_course')
  if (editCourseForm) {
    editCourseForm.addEventListener('ajax:success', (ev) => {
      let response = parseAjaxResponse(ev)
      if (response.data.errors) {
        showErrors(response.data.errors)
      } else if (response.data.status && response.data.location) {
        window.location = response.data.location
      }
    })
  }
})

/**
 * Destroy
 */
document.addEventListener('turbolinks:load', () => {
  let deleteCourseLink = document.querySelector('.link-course-delete')
  if (deleteCourseLink) {
    deleteCourseLink.addEventListener('ajax:success', (ev) => {
      let response = parseAjaxResponse(ev)
      if (response.data.errors) {
        showErrors(response.data.errors)
      } else if (response.data.status && response.data.location) {
        window.location = response.data.location
      }
    })
  }
})
