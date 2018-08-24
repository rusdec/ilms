document.addEventListener('turbolinks:load', () => {
  if (document.querySelector('#mainPageTab') && window.location.hash) {
    $(`#mainPageTab a[href="${window.location.hash}"]`).tab('show');
  }
})
