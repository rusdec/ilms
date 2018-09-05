document.addEventListener('turbolinks:load', () => {
  if (!document.querySelector('#profile-lessons-count-chart')) return

  var myDoughnutChart = new Chart(document.querySelector('#profile-lessons-count-chart'), {
    type: 'doughnut',
    data: {
      datasets: [{
        data: [4],
      }],
      labels: ['Passed']
    },
    options: {
      legend: {
        display: false,
      },
      animation: {
        animateRotate: true
      }
    }
  });
})
