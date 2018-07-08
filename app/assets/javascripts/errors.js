function clearErrors(container) {
  if (container) {
    container.innerHTML = ''
  }
}

function showErrors(errors = [], container) {
  let errorsContainer = container || document.querySelector('.form-errors-container .alert .errors')
  if (errorsContainer && errors) {
    clearErrors(errorsContainer)
    errors.forEach((error) => {
      let p = document.createElement('p')
      p.textContent = error
      errorsContainer.appendChild(p)
    })
    toggleVisibleErrors()
    setTimeout(()=>{toggleVisibleErrors()}, 5000);
  }
}

function toggleVisibleErrors() {
  document.querySelector('.form-errors-container').classList.toggle('hidden')
}

document.addEventListener('turbolinks:load', () => {
  let buttonClose = document.querySelector('.form-errors-container button.close')
  if (buttonClose) {
    buttonClose.addEventListener('click', () => toggleVisibleErrors())
  } 
})
