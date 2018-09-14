document.addEventListener('turbolinks:load', () => {
  let knowledgesDirectionsChart = document.querySelector('#profile-knowledges-directions-chart')
  if (!knowledgesDirectionsChart) return

  (async() => {
    let response = await fetch(
      `/statistics/users/${gon.statistic_user.id}/knowledges_directions.json`
    )
    response = await response.json()

    if (response.length > 0) {
      Highcharts.chart('profile-knowledges-directions-chart', {
        lang: {
          drillUpText: translate('back')
        },
        chart: {
          type: 'pie',
          height: 300
        },
        title: { text: '' },
        subtitle: { text: '' },
        plotOptions: {
          series: {
            dataLabels: {
              enabled: true,
              format: '{point.name}: {point.y}',
              color: '#000',
              borderRadius: 5,
              borderColor: '#e0e0e0',
              borderWidth: 1
            }
          }
        },
        colors: [
          '#5aa1b5', '#a15196', '#9eb354', '#b3615a', '#499969',
          '#bdcfff', '#995264', '#995264', '#7cb566', '#a15eb3',
          '#7cad56', '#e9aeff', '#b35272', '#996149', '#ffe3ae'
        ],
        credits: { enabled: false },
        series: [
          {
            tooltip: { pointFormat: `<span style="color:{point.color}"></span>${translate('sum_of_knowledges_levels')}: <b>{point.y}</b>` },
            name: translate('knowledges_direction'),
            colorByPoint: true,
            data: response.map((kd) => {
              return {
                name: kd.direction,
                y: kd.sum_of_levels,
                drilldown: kd.direction
              }
            })
          }
        ],
        drilldown: {
          drillUpButton: {
            relativeTo: 'spacingBox',
            position: { y: 0, x: 0 },
            theme: {
              fill: 'white',
              'stroke-width': 1,
              stroke: 'silver',
              r: 5,
              states: {
                hover: {
                  fill: '#f0f0f0'
                },
                select: {
                  stroke: '#039',
                  fill: '#a4edba'
                }
              }
            }
          },
          series: response.map((kd) => {
            return {
              id: kd.direction,
              name: kd.direction,
              data: kd.user_knowledges.map((uk) => [uk.knowledge.name, uk.level])
            }
          })
        }
      })  // Highcharts.chart
    } else {
      knowledgesDirectionsChart.parentNode.insertAdjacentHTML(
        'afterbegin', Mustache.render(_p_no_data, {body: translate('no_data')})
      )
      knowledgesDirectionsChart.remove()
    }
  })()    // async
})
