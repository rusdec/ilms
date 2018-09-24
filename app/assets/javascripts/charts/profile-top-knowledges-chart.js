document.addEventListener('turbolinks:load', () => {
  let topKnowledgesChart = document.querySelector('#profile-top-knowledges-chart')
  if (!topKnowledgesChart) return

  (async() => {
    let response = await fetch(
      `/statistics/users/${gon.statistic_user.id}/top_three_knowledges.json`
    )
    response = await response.json()

    if (response.knowledges.length > 0) {
      topKnowledgesChart.height = 70
      new Chart(topKnowledgesChart, {
        type: 'horizontalBar',
        data: {
          datasets: [{
            data: response.knowledges.map((k) => k.level),
            backgroundColor: ['#54a1c7', '#54a1c7', '#54a1c7']
          }],
          labels: response.knowledges.map((k) => k.knowledge.name)
        },
        options: {
          legend: { display: false },
          scales: {
            xAxes: [{
              ticks: {
                beginAtZero: true,
                stepSize: 1,
                min: 1,
                max: response.knowledges[0] ? response.knowledges[0].level + 1 : 1
              },
              gridLines: { drawBorder: false },
            }],
            yAxes: [{
              gridLines: {
                display: false,
                drawBorder: false,
              }
            }],
          } // scales
        }   // options
      })    // new Chart
    } else {
      topKnowledgesChart.parentNode.insertAdjacentHTML(
        'afterbegin', Mustache.render(_p_no_data, {body: translate('no_data')})
      )
      topKnowledgesChart.remove()
    }
  })() // async
})
