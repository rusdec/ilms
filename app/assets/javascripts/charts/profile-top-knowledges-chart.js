document.addEventListener('turbolinks:load', () => {
  if (!document.querySelector('#profile-top-knowledges-chart')) return

  let ctx = document.querySelector('#profile-top-knowledges-chart')
  ctx.height = 90
  new Chart(ctx, {
    type: 'horizontalBar',
    data: {
      datasets: [{
        data: [21, 20, 10],
      }],
      labels: ['OOP', 'Ruby', 'Javascript']
    },
    options: {
      legend: {
        display: false
      },
      scales: {
        xAxes: [{
          ticks: {
            beginAtZero: true
          }
        }]
      }
    }
  });
})
