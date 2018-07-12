document.addEventListener('turbolinks:load', () => {
  ['.edit_quest', '.new_quest', '.destroy_quest'].forEach((selector) => {
    addResponseAlertListener({selector: selector})
  })
})
