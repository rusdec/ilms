document.addEventListener('turbolinks:load', () => {
  let forms = ['.accept_quest_solution', '.decline_quest_solution']

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
    {selector: '.accept_quest_solution',  verify: 'accepted'},
    {selector: '.decline_quest_solution', verify: 'declined'}
  ].forEach((e) => {
    document.querySelector(e.selector).addEventListener('ajax:success', (ev) => {
      let cardTitle = document.querySelector('#quest_solution h3')
      if (cardTitle) {
        cardTitle.textContent = `Solution (${e.verify})`
      }
    })
  })
})
