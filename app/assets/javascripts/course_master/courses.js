document.addEventListener('turbolinks:load', () => {
  ['.edit_course', '.new_course', '.destroy_course'].forEach((selector) => {
    addResponseAlertListener({selector: selector})
  })
})
