document.addEventListener('turbolinks:load', () => {
  let lessonsCountChart = document.querySelector('#profile-lessons-count-chart')
  if (!lessonsCountChart) return

  (async() => {
    let response = await fetch(
      `/statistics/users/${gon.statistic_user.id}/lessons_progress.json`
    )
    response = await response.json()

    if (response.lessons.in_progress) {
      new Chart(lessonsCountChart, {
        type: 'doughnut',
        data: {
          datasets: [{
            data: [
              response.lessons.passed,
              response.lessons.unavailable,
              response.lessons.in_progress
            ],
            backgroundColor: ['#679c6d', '#995463']
          }],
          labels: [
            translate('passed'),
            translate('unavailable'),
            translate('in_progress')
          ]
        },
        options: {
          legend: { position: 'right' },
          animation: { animateRotate: true }
        }
      })
    } else {
      lessonsCountChart.parentNode.insertAdjacentHTML(
        'afterbegin', Mustache.render(_p_no_data, {body: translate('no_data')})
      )
      lessonsCountChart.remove()
    }
  })()
})
