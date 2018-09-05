document.addEventListener('turbolinks:load', () => {
  if (!document.querySelector('#profile-courses-count-chart')) return

  var myDoughnutChart = new Chart(document.querySelector('#profile-courses-count-chart'), {
    type: 'doughnut',
    data: {
      datasets: [{
        data: [2, 10],
      }],
      labels: ['Passed', 'Left']
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
