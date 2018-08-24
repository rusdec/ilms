function remoteLinksListener(itemClass) {
  let items = document.querySelectorAll(`.${itemClass}-item`)
  if (!items) {
    return
  }

  let removeItem = (data) => {
    document.querySelector(`.${itemClass}-item[data-id="${data.object.id}"]`).remove()
  }

  items.forEach((item) => {
    let remoteLink = item.querySelector('.remote-links .destroy')
    alertListenerNormal(remoteLink, {callback: removeItem} )
  })
}
