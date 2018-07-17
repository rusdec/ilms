document.addEventListener('turbolinks:load', () => {
  document.querySelectorAll('.editor').forEach((editor) => {
    const a = new Quill(editor, {
      theme: 'snow',
    })
  })

  document.querySelectorAll('form[form_editor="true"]').forEach((form) => {
    form.querySelectorAll('.editor-container').forEach((container) => {
        let input = container.querySelector('input.textarea')
        let editor = container.querySelector('div.ql-editor')
        editor.innerHTML = input.value
    })

    form.addEventListener('mousedown', () => {
      form.querySelectorAll('.editor-container').forEach((container) => {
        let input = container.querySelector('input.textarea')
        let editor = container.querySelector('div.ql-editor')
        input.value = editor.innerHTML
      })
    })
  })

})

