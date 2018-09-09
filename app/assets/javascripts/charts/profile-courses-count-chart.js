document.addEventListener('turbolinks:load', () => {
  if (!document.querySelector('#profile-courses-count-chart')) return

  (async() => {
    let response = await fetch(
      `/statistics/users/${gon.statistic_user.id}/courses_progress.json`
    )
    response = await response.json()

    new Chart(document.querySelector('#profile-courses-count-chart'), {
      type: 'doughnut',
      data: {
        datasets: [{
          data: [response.courses.passed, response.courses.in_progress],
          backgroundColor: ['#679c6d']
        }],
        labels: ['Passed', 'In progress'],
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
  })()
})
