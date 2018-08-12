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
  let container = document.querySelector('.form-success-container')
  if (!container) { 
    return
  }

  if (container.classList.contains('hidden')) {
    container.classList.remove('hidden')
  } else {
    container.classList.add('hidden')
  }
}

document.addEventListener('turbolinks:load', () => {
  let buttonClose = document.querySelector('.form-success-container button.close')
  if (buttonClose) {
    buttonClose.addEventListener('click', () => toggleVisibleSuccess())
  } 
})
