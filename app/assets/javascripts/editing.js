document.addEventListener('turbolinks:load', () => {
  let editingContainers = document.querySelectorAll('.editing-container')
  if (!editingContainers) {
    return
  }
  editingContainers.forEach((c) => {
    let nonEditing = c.querySelector('.non-editing')
    let form = c.querySelector('.inline_edit')
    if (!form || !nonEditing) {
      return
    }

    [form, nonEditing].forEach((e) => {
      e.querySelector('a').addEventListener('click', () => {
        toggleVisibleEditing(form, nonEditing)
      })
    })

    form.addEventListener('ajax:success', (ev) => {
      let response = parseAjaxResponse(ev)
      if (response.data.errors) {
        showErrors(response.data.errors)
      } else if (response.data.status) {
        showSuccess(response.data.message)
        nonEditing.querySelector('span').innerText = response.data.object.type
        toggleVisibleEditing(form, nonEditing)
      }
    })
  })
})

function toggleVisibleEditing(...elements) {
  elements.forEach((element) => {element.classList.toggle('hidden')})
}
