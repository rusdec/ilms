document.addEventListener('turbolinks:load', () => {
  if (!document.querySelector('#profile-quests-count-chart')) return

  var myDoughnutChart = new Chart(document.querySelector('#profile-quests-count-chart'), {
    type: 'doughnut',
    data: {
      datasets: [{
        data: [10],
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
