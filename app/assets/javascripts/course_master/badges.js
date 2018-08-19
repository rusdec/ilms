document.addEventListener('turbolinks:load', () => {
  let showImage = (data) => {
    let badgeImage = document.querySelector('img[name="badge_image"]')
    if (!badgeImage) {
      return
    }
    badgeImage.src = data.object.image.preview
  }

  ['.edit_badge', '.new_badge', '.destroy_badge'].forEach((selector) => {
    addResponseAlertListener({selector: selector, callback: showImage})
  })
})
