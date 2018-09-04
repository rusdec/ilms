document.addEventListener('turbolinks:load', () => {
  let forms = ['.accept_passage_solution', '.decline_passage_solution']

  let hideForms = () => {
    forms.forEach((form) => {
      form = document.querySelector(form)
      if (form && !form.classList.contains('hidden')) {
        form.classList.add('hidden')
      }
    })
  }

  forms.forEach((selector) => {
    addResponseAlertListener({selector: selector, callback: hideForms})
  })
})

document.addEventListener('turbolinks:load', () => {
  [
    {selector: '.accept_passage_solution',  verify: 'accepted'},
    {selector: '.decline_passage_solution', verify: 'declined'}
  ].forEach((e) => {
    let form = document.querySelector(e.selector)
    let cardTitle = document.querySelector('#passage_solution h4')
    if (!form || !cardTitle) return

    form.addEventListener('ajax:success', () => {
      cardTitle.textContent = `Solution (${e.verify})`
    })
  })
})
