/**
 *  @params Object params
 *    @params String selector
 *    @params Function callback 
 */
function addResponseAlertListener(params = {selector: '', callback: null}) {
  if (!params.selector) {
    return
  }

  let element = document.querySelector(params.selector)
  if (!element) {
    return
  }
  alertListenerForDevise(element, params)
  alertListenerNormal(element, params)
}

function alertListenerNormal(element, params = {}) {

  element.addEventListener('ajax:success', (ev) => {
    let response = parseAjaxResponse(ev)

    if (response.data.location) {
      window.location = response.data.location
      return
    }

    if (response.data.errors) {
      showAlert({
        messages: response.data.errors,
        container: params.container,
        type: 'danger'
      })
      return
    }
    
    if (response.data.message) {
      showAlert({
        messages: [response.data.message],
        container: params.container
      })
    }

    if (params.callback) {
      params.callback(response.data)
    }
  })
}

function alertListenerForDevise(element, params = {}) {
  element.addEventListener('ajax:complete', (ev) => {
    let response = JSON.parse(parseAjaxResponse(ev).data.response)
    if (response.error) {
      showErrors([response.error], params.error_contatiner)
    }
  })
}
