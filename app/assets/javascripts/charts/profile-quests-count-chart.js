document.addEventListener('turbolinks:load', () => {
  let questsCountChart = document.querySelector('#profile-quests-count-chart')
  if (!questsCountChart) return

  (async() => {
    let response = await fetch(
      `/statistics/users/${gon.statistic_user.id}/quests_progress.json`
    )
    response = await response.json()

    if (response.quests.in_progress) {
      new Chart(document.querySelector('#profile-quests-count-chart'), {
        type: 'doughnut',
        data: {
          datasets: [{
            data: [response.quests.passed, response.quests.in_progress],
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
