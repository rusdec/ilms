document.addEventListener('turbolinks:load', () => {
  let passage = () => document.querySelector('#passage')
  if (!passage() || passage().dataset.status == 'passed') {
    return
  }
  let scrollHeight = document.body.scrollHeight
  let innerHeight = window.innerHeight

  let isNotRequested = true
  window.onscroll = () => {
    let currentHeight = (innerHeight + window.scrollY) + 20
    let isNotPassed = passage().dataset.status != 'passed'
    if ((currentHeight >= scrollHeight) && isNotRequested && isNotPassed) {
      tryPass(passage().dataset.id)
      isNotRequested = false
    }
  }
})

function tryPass(id = null) {
  if (!id) {
    return
  }

  (async () => {
    const rawResponse = await fetch(`/passages/${id}/try_pass`, {
      method: 'PATCH',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-CSRF-Token': getCSRFToken()
      },
    });
    const content = await rawResponse.json();
    document.querySelector('#passage').dataset.status = content.object.status.name 
  })();
}
