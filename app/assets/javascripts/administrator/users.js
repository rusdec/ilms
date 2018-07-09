document.addEventListener('turbolinks:load', () => {
  ['.edit_user', '.new_user', '.destroy_user'].forEach((selector) => {
    addResponseAlertListener({selector: selector})
  })
})
