/**
 * Redraw knowledge table/list elements after course updating
 */
document.addEventListener('turbolinks:load', () => {
  let formUpdateCourse = document.querySelector('form.edit_course')
  if (!formUpdateCourse) return

  let knowledgeTable = document.querySelector('tbody.course-knowledge-items')
  if (!knowledgeTable) return

  let knowledgeList = document.querySelector('#knowledge-items')
  if (!knowledgeList) return

  formUpdateCourse.addEventListener('ajax:success', (ev) => {
    let response = parseAjaxResponse(ev)
    if (!response.data.object) return 

    /**
     * Table
     */
    knowledgeTable.innerHTML = ''
    response.data.object.course_knowledges.forEach((courseKnowledge, key) => {
      courseKnowledge['key'] = key
      courseKnowledge.knowledge.name = normalizeText(courseKnowledge.knowledge.name)
      knowledgeTable.insertAdjacentHTML('beforeend',
        Mustache.render(_tr_knowledges, courseKnowledge)
      )

      let insertedElement = knowledgeTable.children[knowledgeTable.children.length - 1]
      listenInputValueLimit(insertedElement)
      listenMarkedForDestruction(insertedElement)
      updateProgressBar(insertedElement.querySelector('.progress-bar'), courseKnowledge.percent)
    })

    /**
     * List
     */
    knowledgeList.innerHTML = ''
    response.data.object.free_knowledges.forEach((freeKnowledge, key) => {
      insertToList({id: freeKnowledge.id, name: freeKnowledge.name, order: key})
    })
  })
})

document.addEventListener('turbolinks:load', () => {
  /**
   * Knowledges from Table to List
   */
  let tableItems = document.querySelectorAll('tbody.course-knowledge-items .course-knowledge-item')
  if (!tableItems) return

  tableItems.forEach((tableItem) => {
    listenInputValueLimit(tableItem)
    listenMarkedForDestruction(tableItem)
  })

  /**
   * Knowledge from List to Table
   */
  let listItems = document.querySelectorAll('#knowledge-items .knowledge-item')
  if (!listItems) return

  listItems.forEach((listItem) => { listenInsertToTable(listItem) })

  /**
   * Knowledge from Input to Table
   */
  let newKnowledgeInput = document.querySelector('#new-knowledge')
  if (!newKnowledgeInput) return

  let buttonAddNewKnowledge = document.querySelector('#add-new-knowledge')
  if (!newKnowledgeInput) return

  buttonAddNewKnowledge.addEventListener('click', () => {
    if (totalKnowledgePercent() >= 100) return 
    newKnowledgeInput.dataset.name = newKnowledgeInput.value
    insertToTable(newKnowledgeInput)
  })

  updateTotalKnowledgePercent()
})

 /**
 * @params Object knowledge
 *  @attribute String name
 *  @attribute Integer|Null id
 */
function insertToTable(knowledge) {
  let tableBody = document.querySelector('tbody.course-knowledge-items')
  if (!tableBody) return

  tableBody.insertAdjacentHTML('beforeend', Mustache.render(_td_knowledge, {
    id: knowledge.dataset.id,
    name: knowledge.dataset.name,
    normalizedName: normalizeText(knowledge.dataset.name),
    count: document.querySelectorAll('.course-knowledge-item').length
  }))

  let insertedElement = tableBody.children[tableBody.children.length - 1]

  listenInputValueLimit(insertedElement)
  listenRemoveFromTable(insertedElement)
  updateTotalKnowledgePercent()
}

/**
 * @params Object knowledge
 *  @params String name
 *  @params Integer|Null id
 */
function insertToList(knowledge) {
  let knowledgeItems = document.querySelector('#knowledge-items')
  if (!knowledgeItems) return

  knowledgeItems.insertAdjacentHTML('afterbegin', Mustache.render(_li_knowledge, {
    id: knowledge.id,
    name: knowledge.name,
    normalizedName: normalizeText(knowledge.name)
  }))
  listenInsertToTable(knowledgeItems.children[0])
}

function updateProgressBar(progressBar, value) {
    if (parseInt(progressBar['aria-valuenow']) == value) return

    let color = progressColor(value)

    progressBar = removeColors(progressBar)
    progressBar.classList.add(color)
    progressBar.style.width = `${value}%`
    progressBar['aria-valuenow'] = value
}

function listenInsertToTable(element) {
  element.addEventListener('click', () => {
    if (totalKnowledgePercent() >= 100) return

    insertToTable(element)
    listenRemoveFromTable(element)
    element.remove()
  })
}

function listenRemoveFromTable(element) {
  let remover = element.querySelector('.remove-knowledge')
  if (!remover) return

  remover.addEventListener('click', () => {
    element.remove()
    updateTotalKnowledgePercent()

    if (element.dataset.id != '') {
      insertToList({id: element.dataset.id, name: element.dataset.name})
    }
  })
}

function listenMarkedForDestruction(element) {
  let checkbox = element.querySelector('.check-for-destruction')
  if (!checkbox) return

  checkbox.addEventListener('change', () => {
    element.dataset.checkedForDestruction = checkbox.checked
    element.querySelector('input.percent').disabled = checkbox.checked

    element.querySelectorAll('td:not(.td-del)').forEach((disabledElement) => { 
      if (checkbox.checked) {
        disabledElement.style.opacity = 0.2
      } else {
        disabledElement.style.opacity = 1
      }
    })
    updateTotalKnowledgePercent()
  })
}

function listenInputValueLimit(element) {
  let maxValue = 100
  let elementPercentInput = element.querySelector('input.percent')
  let progressBar = element.querySelector('.progress-bar')
  
  elementPercentInput.addEventListener('input', () => {
    let elementPercentValue = parseInt(elementPercentInput.value)
    let accum = totalKnowledgePercent()
    let currentMaxPercentValue = maxValue - (accum - elementPercentValue)

    if (elementPercentValue <= 0 || isNaN(elementPercentValue)) {
      // percent 0, -1, -1000, ...
      elementPercentInput.value = 1
    } else if (accum >= maxValue) {
      // percent 101, 123, ...
      elementPercentInput.max = currentMaxPercentValue
      elementPercentInput.value = currentMaxPercentValue
    } else { elementPercentInput.max = maxValue }
  
    updateTotalKnowledgePercent()
    updateProgressBar(progressBar, elementPercentInput.value)
  })
}

function updateTotalKnowledgePercent() {
  let totalPercent = document.querySelector('#totalKnowledgePercent')
  if (!totalPercent) return
  totalPercent.innerText = `${totalKnowledgePercent()}% `
  if (totalKnowledgePercent() >= 100) {
    totalPercent.classList.add('text-danger')
  } else {
    totalPercent.classList.remove('text-danger')
  }
}

let totalKnowledgePercent = () => {
  let accum = 0
  document.querySelectorAll(
    'tr.course-knowledge-item[data-checked-for-destruction="false"] input.percent'
  ).forEach((percentInput) => { accum += parseInt(percentInput.value) })
  return accum
}
