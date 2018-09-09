document.addEventListener('turbolinks:load', () => {
  if (!document.querySelector('#profile-lessons-count-chart')) return

  (async() => {
    let response = await fetch(
      `/statistics/users/${gon.statistic_user.id}/lessons_progress.json`
    )
    response = await response.json()

    new Chart(document.querySelector('#profile-lessons-count-chart'), {
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
        labels: ['Passed', 'Unavailable', 'In progress']
      },
      options: {
        legend: { position: 'right' },
        animation: { animateRotate: true }
      }
    })
  })()
})
