document.addEventListener('turbolinks:load', () => {
  let waitingVerification = () => {
    let form = document.querySelector('.new_quest_solution')
    if (form && !form.classList.contains('hidden')) {
      form.classList.add('hidden')
    }
    form.parentNode.innerHTML = form.parentNode.innerHTML + wait_verification_card
  }

  ['.new_quest_solution'].forEach((selector) => {
    addResponseAlertListener({selector: selector, callback: waitingVerification})
  })
})
