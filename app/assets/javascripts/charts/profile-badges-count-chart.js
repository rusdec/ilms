document.addEventListener('turbolinks:load', () => {
  if (!document.querySelector('#profile-badges-count-chart')) return

  new Chart(document.querySelector('#profile-badges-count-chart'), {
    type: 'doughnut',
    data: {
      datasets: [{
        data: [
          gon.statistic.badges_progress.badges.collected,
          gon.statistic.badges_progress.badges.total - gon.statistic.badges_progress.badges.collected
        ],
        backgroundColor: ['#679c6d']
      }],
      labels: ['Collected', 'Left'],
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
})
