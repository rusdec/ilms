document.addEventListener('turbolinks:load', () => {
  $('[data-toggle="popover"]').popover({
    html: true,
    trigger: 'hover'
  })
})
