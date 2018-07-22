document.addEventListener('turbolinks:load', () => {
  ['.new_quest_solution'].forEach((selector) => {
    addResponseAlertListener({selector: selector})
  })
})
