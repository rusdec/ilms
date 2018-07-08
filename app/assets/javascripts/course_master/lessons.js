/**
 * Edit
 */
document.addEventListener('turbolinks:load', () => {
  let form = document.querySelector('.edit_lesson')
  if (form) {
    form.addEventListener('ajax:success', (ev) => {
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
  let form = document.querySelector('.new_lesson')
  if (form) {
    form.addEventListener('ajax:success', (ev) => {
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
  let link = document.querySelector('.destroy_lesson')
  if (link) {
    link.addEventListener('ajax:success', (ev) => {
      let response = parseAjaxResponse(ev)
      if (response.data.errors) {
        showErrors(response.data.errors)
      } else if (response.data.status && response.data.location) {
        window.location = response.data.location
      }
    })
  }
})
