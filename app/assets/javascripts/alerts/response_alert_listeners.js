/**
 *  params
 *    selector: string
 */
function addResponseAlertListener(params) {
  if (!params.selector) {
    return
  }

  let selector = document.querySelector(params.selector)
  if (!selector) {
    return
  }

  /**
   * Devise
   */
  selector.addEventListener('ajax:complete', (ev) => {
    let response = JSON.parse(parseAjaxResponse(ev).data.response)
    if (response.error) {
      showErrors([response.error])
    }
  })

  selector.addEventListener('ajax:success', (ev) => {
    let response = parseAjaxResponse(ev)
    if (response.data.errors) {
      showErrors(response.data.errors)
    } else if (response.data.status) {
      if (response.data.location) {
        window.location = response.data.location
      } else {
        showSuccess(response.data.message)
      }
    }
  })
}
