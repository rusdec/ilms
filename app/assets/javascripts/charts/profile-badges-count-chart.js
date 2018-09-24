document.addEventListener('turbolinks:load', () => {
  let badgesCountChart = document.querySelector('#profile-badges-count-chart')
  if (!badgesCountChart) return

  (async() => {
    let response = await fetch(
      `/statistics/users/${gon.statistic_user.id}/badges_progress.json`
    )
    response = await response.json()
    
    if (response.badges.total) {
      new Chart(badgesCountChart, {
        type: 'doughnut',
        data: {
          datasets: [{
            data: [
              response.badges.collected,
              response.badges.total - response.badges.collected
            ],
            backgroundColor: ['#679c6d']
          }],
          labels: [translate('collected'), translate('left')],
        },
        options: {
          legend: { position: 'right' },
          animation: { animateRotate: true }
        }
      })
    } else {
      badgesCountChart.parentNode.insertAdjacentHTML(
        'afterbegin', Mustache.render(_p_no_data, {body: translate('no_data')})
      )
      badgesCountChart.remove()
    }
  })()
})
