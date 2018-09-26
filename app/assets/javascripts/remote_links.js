function remoteLinksListener(itemClass) {
  let items = document.querySelectorAll(`.${itemClass}-item`)
  if (!items) {
    return
  }

  let removeItem = (data) => {
    document.querySelector(`.${itemClass}-item[data-id="${data.object.id}"]`).remove()
  }

  /**
   * update elements count in tabs
   * Example: Lessons(1) -> Lessons(0)
   * */
  let updateCount = () => {
    let countContainer = document.querySelector(`.count-${itemClass}`);
    if (!countContainer) return
    countContainer.innerText = `(${document.querySelectorAll(`.${itemClass}-item`).length})`
  }

  let callback = (data) => {
    removeItem(data)
    updateCount()
  }

  items.forEach((item) => {
    let remoteLink = item.querySelector('.remote-links .destroy')
    alertListenerNormal(remoteLink, {callback: callback} )
  })
}
