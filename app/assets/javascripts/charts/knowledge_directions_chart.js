document.addEventListener('turbolinks:load', () => {
  if (!document.querySelector('#knowledge-directions-chart')) return

  Highcharts.chart('knowledge-directions-chart', {
    chart: {
      polar: true,
      type: 'line'
    },
    title: {
      text: ''
    },
    pane: {
      size: '70%'
    },
    legend: {
      enabled: false
    },
    credits: {
      enabled: false
    },
    xAxis: {
        categories: ['Администрирование Linux', 'ПУА', 'PHP', 'Коммуникация', 'CMS'],
        tickmarkPlacement: 'on',
        lineWidth: 0
    },
    yAxis: {
      gridLineInterpolation: 'polygon',
      lineWidth: 0,
      min: 0
    },
    tooltip: {
      shared: true,
      pointFormat: '<span style="color:{series.color}">{series.name}: <b>${point.y:,.0f}</b><br/>'
    },
    series: [{
      name: 'Allocated Budget',
      data: [3, 8, 21, 15, 17],
      pointPlacement: 'on'
    }]
  });
})
