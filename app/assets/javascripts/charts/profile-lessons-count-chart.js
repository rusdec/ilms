document.addEventListener('turbolinks:load', () => {
  if (!document.querySelector('#profile-lessons-count-chart')) return

  new Chart(document.querySelector('#profile-lessons-count-chart'), {
    type: 'doughnut',
    data: {
      datasets: [{
        data: [
          gon.statistic.lessons_progress.lessons.passed,
          gon.statistic.lessons_progress.lessons.unavailable,
          gon.statistic.lessons_progress.lessons.in_progress
        ],
        backgroundColor: ['#679c6d', '#995463']
      }],
      labels: ['Passed', 'Unavailable', 'In progress']
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
