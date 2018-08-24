function formLinksListener(itemClass = '', params = {}) {
  if (!itemClass) {
    return
  }
  document.querySelectorAll(`form.edit_${itemClass}, form.new_${itemClass}`).forEach((form) => alertListenerNormal(form, params = {}))
}
