document.addEventListener('turbolinks:load', () => {
  ['.edit_quest', '.new_quest', '.destroy_quest'].forEach((selector) => {
    addResponseAlertListener({selector: selector})
  })
})

document.addEventListener('turbolinks:load', () => {
  let editQuestForm = document.querySelector('.edit_quest')
  if (!editQuestForm) { return }
  editQuestForm.addEventListener('ajax:success', (ev) => {
    let response = parseAjaxResponse(ev)
    if (response.data.errors || !response.data.status) { return }
    let output = Mustache.render(radio_quest_groups_template, response.data.object)
    document.querySelector('.quest-groups').innerHTML = output;
  })
})
