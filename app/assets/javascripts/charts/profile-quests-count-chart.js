document.addEventListener('turbolinks:load', () => {
  let questsCountChart = document.querySelector('#profile-quests-count-chart')
  if (!questsCountChart) return

  (async() => {
    let response = await fetch(
      `/statistics/users/${gon.statistic_user.id}/quests_progress.json`
    )
    response = await response.json()
    let quests = response.quests

    if (quests.in_progress || quests.passed) {
      new Chart(document.querySelector('#profile-quests-count-chart'), {
        type: 'doughnut',
        data: {
          datasets: [{
            data: [quests.passed, quests.in_progress],
            backgroundColor: ['#679c6d']
          }],
          labels: [translate('passed'), translate('in_progress')]
        },
        options: {
          legend: { position: 'right' },
          animation: { animateRotate: true }
        }
      })
    } else {
      questsCountChart.parentNode.insertAdjacentHTML(
        'afterbegin', Mustache.render(_p_no_data, {body: translate('no_data')})
      )
      questsCountChart.remove()
    }
  })()
})
