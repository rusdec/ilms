document.addEventListener('turbolinks:load', () => {
  if (!document.querySelector('#profile-quests-count-chart')) return

  new Chart(document.querySelector('#profile-quests-count-chart'), {
    type: 'doughnut',
    data: {
      datasets: [{
        data: [
          gon.statistic.quests_progress.quests.passed,
          gon.statistic.quests_progress.quests.in_progress
        ],
        backgroundColor: ['#679c6d']
      }],
      labels: ['Passed', 'In progress']
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
