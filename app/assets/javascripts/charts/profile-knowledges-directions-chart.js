document.addEventListener('turbolinks:load', () => {
  if (!document.querySelector('#profile-knowledges-directions-chart')) return
  let ctx1 = document.querySelector('#profile-knowledges-directions-chart')
  new Chart(ctx1, {
    type: 'radar',
    data: {
      datasets: [{
        data: [6, 2, 0, 0, 0, 0, 0, 0, 0],
        fill: true
      }],
      labels: ['Programming languages', 'Programming paradigms', '', '', '', '', '', '', '']
    },
    options: {
      legend: {
        display: false
      },
      elements: {
        line: {
          tension: 0,
          borderWidth: 2
        }
      }
    }
  });
})
