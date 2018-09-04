document.addEventListener('turbolinks:load', () => {
  let passage = () => document.querySelector('#passage')
  if (!passage() || passage().dataset.status == 'passed') return

  let scrollHeight = document.body.scrollHeight
  let innerHeight = window.innerHeight
  let isNotPassed = () => { return passage().dataset.status != 'passed' }

  /**
   * Autopass
   */
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

  let materials = document.querySelectorAll('#materials .card')
  if (!materials) return
  markAsCurrentListItem(lessonContentList.children[0])

  /**
   * Scroll to material
   */
  lessonContentList.querySelectorAll('.list-group-item').forEach((listItem) => {
    listItem.addEventListener('click', () => {
      document.querySelector(`#materials ${listItem.attributes.href.value}`).scrollIntoView()
    })
  })

  window.onscroll = () => {
    /**
     * Fix content menu
     */
    let currentHeight = (window.innerHeight + window.scrollY)
    if (currentHeight > window.innerHeight + 20) {
      lessonContentList.classList.add('sticky-top')
    } else {
      lessonContentList.classList.remove('sticky-top')
    }

    /**
     * Mark current material
     */
    materials.forEach((material) => {
      if (!isMaterialOnTop(material)) return
      unmarkMarkedListItem()
      markAsCurrentListItem(lessonContentList.querySelector(`.list-group-item[href="#${material.id}"]`))
    })
  }
})

function markAsCurrentListItem(element) {
  if (!element) return

  element.classList.add('border-left', 'border-success', 'rounded-0', 'font-weight-bold')
}

function unmarkMarkedListItem() {
  let marked = document.querySelector('#lesson-content-list .border-success')
  if (!marked) return

  marked.classList.remove('border-left', 'border-success', 'rounded-0', 'font-weight-bold')
}

function isMaterialOnTop(material) {
  return material.getBoundingClientRect().top < 100
}

function tryPass(id = null) {
  if (!id) return

  (async () => {
    const rawResponse = await fetch(`/passages/${id}/try_pass`, {
      method: 'PATCH',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-CSRF-Token': getCSRFToken()
      },
    })
    const content = await rawResponse.json();
    document.querySelector('#passage').dataset.status = content.object.status.name 
  })()
}
