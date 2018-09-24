/**
 * @params Hash params
 *  @params Array messages
 *    @params String item
 *  @params Object container 
 *  @params String type => Any bootstrap alert-types: success, danger, warning etc
 */
function showAlert(params = {messages: [], container: null, type: ''}) {
  params.container = params.container || document.querySelector('.body .container')
  params.type = params.type || 'success'

  if (params.container && params.messages) {
    params.container.insertAdjacentHTML('afterbegin', Mustache.render(_alert, params))
  }
}
