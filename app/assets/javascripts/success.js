function clearSuccess(container) {
  if (container) {
    container.innerHTML = ''
  }
}

function showSuccess(message = '', container) {
  let successContainer = container || document.querySelector('.form-success-container .alert .message')
  if (successContainer && message) {
    clearSuccess(successContainer)
    let span = document.createElement('span')
    span.textContent = message
    successContainer.appendChild(span)
    toggleVisibleSuccess()
    setTimeout(()=>{toggleVisibleSuccess()}, 3000);
  }
}

function toggleVisibleSuccess() {
  document.querySelector('.form-success-container').classList.toggle('hidden')
}

document.addEventListener('turbolinks:load', () => {
  let buttonClose = document.querySelector('.form-success-container button.close')
  if (buttonClose) {
    buttonClose.addEventListener('click', () => toggleVisibleSuccess())
  } 
})
