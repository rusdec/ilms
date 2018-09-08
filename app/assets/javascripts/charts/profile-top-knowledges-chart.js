document.addEventListener('turbolinks:load', () => {
  if (!document.querySelector('#profile-top-knowledges-chart')) return

  let ctx = document.querySelector('#profile-top-knowledges-chart')
  ctx.height = 65

  new Chart(ctx, {
    type: 'horizontalBar',
    data: {
      datasets: [{
        data: gon.statistic.top_three_knowledges.knowledges.map((k) => k.level),
        backgroundColor: ['#54a1c7', '#54a1c7', '#54a1c7']
      }],
      labels: gon.statistic.top_three_knowledges.knowledges.map((k) => k.knowledge.name)
    },
    options: {
      legend: { display: false },
      scales: {
        xAxes: [{
          ticks: {
            beginAtZero: true,
            stepSize: 1,
            min: 1,
            max: gon.statistic.top_three_knowledges.knowledges[0].level + 1
          },
          gridLines: {
            drawBorder: false },
        }],
        yAxes: [{
          gridLines: {
            display: false,
            drawBorder: false,
          }
        }],
      }
    }
  })
})
