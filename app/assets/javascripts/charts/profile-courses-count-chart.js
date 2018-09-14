document.addEventListener('turbolinks:load', () => {
  let coursesCountChart = document.querySelector('#profile-courses-count-chart')
  if (!coursesCountChart) return

  (async() => {
    let response = await fetch(
      `/statistics/users/${gon.statistic_user.id}/courses_progress.json`
    )
    response = await response.json()

    if (response.courses.in_progress) {
      new Chart(document.querySelector('#profile-courses-count-chart'), {
        type: 'doughnut',
        data: {
          datasets: [{
            data: [response.courses.passed, response.courses.in_progress],
            backgroundColor: ['#679c6d']
          }],
          labels: [translate('passed'), translate('in_progress')],
        },
        options: {
          legend: {
            position: 'right'
          },
          animation: {
            animateRotate: true
          }
        }
      })
    } else {
      coursesCountChart.parentNode.insertAdjacentHTML(
        'afterbegin', Mustache.render(_p_no_data, {body: translate('no_data')})
      )
      coursesCountChart.remove()
    }
  })()
})
