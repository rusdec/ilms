document.addEventListener('turbolinks:load', () => {
  let courseKnowledgeItems = document.querySelector('tbody.course-knowledge-items')
  if (!courseKnowledgeItems) return

  /**
   * all knowledge-items
   */
  let knowledgeItems = document.querySelector('#knowledge-items')
  if (!knowledgeItems) return

  knowledgeItems.querySelectorAll('.knowledge-item').forEach((knowledgeItem) => {
    listenInsertToTable(knowledgeItem)
  })

  /**
   * new-knowledge
   */
  let newKnowledgeInput = document.querySelector('#new-knowledge')
  if (!newKnowledgeInput) return

  let buttonAddNewKnowledge = document.querySelector('#add-new-knowledge')
  if (!newKnowledgeInput) return

  buttonAddNewKnowledge.addEventListener('click', () => {
    newKnowledgeInput.dataset.name = newKnowledgeInput.value
    insertToTable(newKnowledgeInput)
  })
})

/**
 * @params Object knowledge
 *  @attribute String name
 *  @attribute Integer|Null id
 */
function insertToTable(knowledge) {
  let courseKnowledgeItems = document.querySelector('tbody.course-knowledge-items')
  if (!courseKnowledgeItems) return
  
  courseKnowledgeItems.insertAdjacentHTML('beforeend', Mustache.render(_td_knowledge, {
    id: knowledge.dataset.id,
    name: knowledge.dataset.name,
    normalizedName: normalizeText(knowledge.dataset.name)
  }))

  resetCourseKnowledgeValues()
  courseKnowledgeListenLimit(courseKnowledgeItems.lastChild)
  listenRemoveFromTable(courseKnowledgeItems.lastChild)
}

/**
 * @params Object knowledge
 *  @attribute String name
 *  @attribute Integer|Null id
 */
function insertToList(knowledge) {
  let knowledgeItems = document.querySelector('#knowledge-items')
  if (!knowledgeItems) return

  knowledgeItems.insertAdjacentHTML('afterbegin', Mustache.render(_li_knowledge, {
    id: knowledge.dataset.id,
    name: knowledge.dataset.name,
    normalizedName: normalizeText(knowledge.dataset.name)
  }))
  listenInsertToTable(knowledgeItems.children[0])
}

function resetCourseKnowledgeValues() {
  let maxValue = 100
  let courseKnowledgeItems = document.querySelectorAll('.course-knowledge-item')
  let averageValue = parseInt(maxValue/parseInt(courseKnowledgeItems.length))

  courseKnowledgeItems.forEach((courseKnowledgeItem) => {
    updateProgressBar(courseKnowledgeItem.querySelector('.progress-bar'), averageValue)
    courseKnowledgeItem.querySelector('input.percent').value = averageValue
  })
}

function removeColors(element) {
  for(i = 0; i < element.classList.length; i++) {
    if (/^bg-[a-z\-]+$/.test(element.classList[i])) {
      element.classList.remove(element.classList[i])
    }
  }
  return element
}

function updateProgressBar(progressBar, value) {
    if (parseInt(progressBar['aria-valuenow']) == value) return

    let color = rangeColor(value)

    progressBar = removeColors(progressBar)
    progressBar.classList.add(color)
    progressBar.style.width = `${value}%`
    progressBar['aria-valuenow'] = value
}

function listenInsertToTable(element) {
  element.addEventListener('click', () => {
    insertToTable(element)
    listenRemoveFromTable(element)
    element.remove()
  })
}

function listenRemoveFromTable(element) {
  let remover = element.querySelector('#remove-knowledge')
  if (!remover) return

  remover.addEventListener('click', () => {
    element.remove()
    if (element.dataset.id == '') return
    insertToList(element)
  })
}

function courseKnowledgeListenLimit(element) {
  let maxValue = 100
  let elementPercentInput = element.querySelector('input.percent')
  let progressBar = element.querySelector('.progress-bar')
  
  elementPercentInput.addEventListener('input', () => {
    let accum = 0
    element.parentElement.querySelectorAll('input.percent').forEach((percentInput) => {
      accum += Number.parseInt(percentInput.value)
      if (accum >= maxValue) {
        elementPercentInput.max -= (accum - maxValue)
        elementPercentInput.value -= (accum - maxValue)
        accum = maxValue
      } else { elementPercentInput.max = maxValue }
      updateProgressBar(progressBar, elementPercentInput.value)
    })
  })
}
