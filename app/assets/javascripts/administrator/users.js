document.addEventListener('turbolinks:load', () => {
  let editingContainers = document.querySelectorAll('.editing-container')
  if (!editingContainers) { return }
  document.querySelectorAll('.user-item form').forEach((userItem) => {
    userItem.addEventListener('ajax:success', (ev) => {
      let response = parseAjaxResponse(ev)
      let role = response.data.object.type.replace(
        /([A-Z][a-z]+)([A-Z][a-z])/,'$1_$2'
      ).toLowerCase()
      userItem.parentNode.querySelector('.non-editing span').innerText = translate(role)
    })
  })
})
