document.addEventListener('turbolinks:load', () => {
  ['.new_course_passage'].forEach((selector) => {
    addResponseAlertListener({selector: selector})
  })
})
