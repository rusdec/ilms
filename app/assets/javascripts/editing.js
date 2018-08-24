document.addEventListener('turbolinks:load', () => {
  let editingContainers = document.querySelectorAll('.editing-container')
  if (!editingContainers) { return }

  editingContainers.forEach((c) => {
    let nonEditing = c.querySelector('.non-editing')
    let form = c.querySelector('.inline_edit')
    if (!form || !nonEditing) { return }

    let toggleVisible = () => { toggleVisibleEditing(form, nonEditing) }

    [form, nonEditing].forEach((e) => {
      e.querySelector('a').addEventListener('click', () => toggleVisible() )
    })

    alertListenerNormal(form, {callback: toggleVisible})
  })
})

function toggleVisibleEditing(...elements) {
  elements.forEach((element) => {element.classList.toggle('hidden')})
}
