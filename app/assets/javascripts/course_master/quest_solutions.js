document.addEventListener('turbolinks:load', () => {
  ['.accept_quest_solution', '.decline_quest_solution'].forEach((selector) => {
    addResponseAlertListener({selector: selector})
  })
})

document.addEventListener('turbolinks:load', () => {
  [
    {selector: '.accept_quest_solution',  verify: 'Accepted'},
    {selector: '.decline_quest_solution', verify: 'Declined'}
  ].forEach((e) => {
    document.querySelector(e.selector).addEventListener('ajax:success', (ev) => {
      let cardTitle = document.querySelector('#quest_solution h3')
      if (cardTitle) {
        cardTitle.textContent = `Solution (${e.verify})`
      }
    })
  })
})
