document.addEventListener('turbolinks:load', () => {
  let waitingVerification = () => {
    let form = document.querySelector('.new_passage_solution')
    if (form && !form.classList.contains('hidden')) {
      form.classList.add('hidden')
    }

    form.parentNode.insertAdjacentHTML('afterbegin', Mustache.render(_wait_verification_card, {
      title: translate('waiting_for_verification'),
      body: form.querySelector('.ql-editor').innerHTML
    }))
  }

  ['.new_passage_solution'].forEach((selector) => {
    addResponseAlertListener({selector: selector, callback: waitingVerification})
  })
})
