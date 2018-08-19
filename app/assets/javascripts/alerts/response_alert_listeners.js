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
      showErrors([response.error], params.error_contatiner)
    }
  })

  selector.addEventListener('ajax:success', (ev) => {
    let response = parseAjaxResponse(ev)

    if (response.data.location) {
      window.location = response.data.location
      return
    }

    if (response.data.errors) {
      showErrors(response.data.errors, params.error_container)
      return
    }
    
    if (response.data.message) {
      showSuccess(response.data.message)
    }

    if (params.callback) {
      params.callback(response.data)
    }
  })
}
