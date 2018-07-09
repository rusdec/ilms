document.addEventListener('turbolinks:load', () => {
  ['.edit_lesson', '.new_lesson', '.destroy_lesson'].forEach((selector) => {
    addResponseAlertListener({selector: selector})
  })
})
