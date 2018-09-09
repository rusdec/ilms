document.addEventListener('turbolinks:load', () => {
  if (!document.querySelector('#profile-badges-count-chart')) return

  (async() => {
    let response = await fetch(
      `/statistics/users/${gon.statistic_user.id}/badges_progress.json`
    )
    response = await response.json()

    new Chart(document.querySelector('#profile-badges-count-chart'), {
      type: 'doughnut',
      data: {
        datasets: [{
          data: [
            response.badges.collected,
            response.badges.total - response.badges.collected
          ],
          backgroundColor: ['#679c6d']
        }],
        labels: ['Collected', 'Left'],
      },
      options: {
        legend: { position: 'right' },
        animation: { animateRotate: true }
      }
    })
  })()
})
