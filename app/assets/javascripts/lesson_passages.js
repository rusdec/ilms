document.addEventListener('turbolinks:load', () => {
  let passage = () => document.querySelector('#passage')
  if (!passage() || passage().dataset.status == 'passed') {
    return
  }
  let scrollHeight = document.body.scrollHeight
  let innerHeight = window.innerHeight
  let isNotPassed = () => { return passage().dataset.status != 'passed' }

  if (scrollHeight == innerHeight) {
    if (isNotPassed()) {
      tryPass(passage().dataset.id)
    }
  } else {
    isNotRequested = true
    window.onscroll = () => {
      let currentHeight = (innerHeight + window.scrollY) + 20
      if ((currentHeight >= scrollHeight) && isNotRequested && isNotPassed()) {
        tryPass(passage().dataset.id)
        isNotRequested = false
      }
    }
  }
})

document.addEventListener('turbolinks:load', () => {
  let lessonContentList = document.querySelector('#lesson-content-list')
  if (!lessonContentList) return

  let originalPosition = lessonContentList.style.position
  let originalTop = lessonContentList.style.top

  window.onscroll = () => {
    let currentHeight = (innerHeight + window.scrollY)
    if (currentHeight > window.innerHeight + 20) {
      lessonContentList.style.position = 'fixed'
      lessonContentList.style.top = '0px'
    } else {
      lessonContentList.style.position = originalPosition
      lessonContentList.style.top = originalTop
    }

  }

  let materials = document.querySelectorAll('#materials .card')
  markAsCurrentListItem(lessonContentList.children[0])

  window.addEventListener('scroll', () => {
    materials.forEach((material) => {
      if (isMaterialOnTop(material)) {
        unmarkMarkedListItem()
        markAsCurrentListItem(lessonContentList.querySelector(`a[href="#${material.id}"]`))
      }
    })
  })
})

function markAsCurrentListItem(element) {
  element.classList.add('border-left', 'border-success', 'rounded-0', 'font-weight-bold')
}

function unmarkMarkedListItem() {
  let marked = document.querySelector('#lesson-content-list a.border-success')
  if (marked) marked.classList.remove('border-left', 'border-success', 'rounded-0', 'font-weight-bold')
}

function isMaterialOnTop(material) {
  return material.getBoundingClientRect().top < 100
}

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
