document.addEventListener('turbolinks:load', () => {
  if (!document.querySelector('#profile-courses-count-chart')) return

  new Chart(document.querySelector('#profile-courses-count-chart'), {
    type: 'doughnut',
    data: {
      datasets: [{
        data: [
          gon.statistic.courses_progress.courses.passed,
          gon.statistic.courses_progress.courses.in_progress
        ],
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
})
