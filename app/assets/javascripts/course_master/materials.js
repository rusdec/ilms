document.addEventListener('turbolinks:load', () => {
  ['.edit_material', '.new_material', '.destroy_material'].forEach((selector) => {
    addResponseAlertListener({selector: selector})
  })
})
