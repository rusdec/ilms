document.addEventListener('turbolinks:load', () => {
  ['.edit_badge', '.new_badge', '.destroy_badge'].forEach((selector) => {
    addResponseAlertListener({selector: selector})
  })
})
