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

/**
 * #new-knowledge-direction
 */
document.addEventListener('turbolinks:load', () => {
  let input = document.querySelector('#new-knowledge-direction')
  if (!input) return
  inputListenMaxMinValues({input: input, min: 3, max: 50})
})

/**
 * #new-knowledge
 */
document.addEventListener('turbolinks:load', () => {
  let input = document.querySelector('#new-knowledge')
  if (!input) return
  inputListenMaxMinValues({input: input, min: 3, max: 50})
})

document.addEventListener('turbolinks:load', () => {
  let inputGroup = document.querySelector('#new-knowledge-direction-input-group .input-group')
  let newKnowledgeInput = document.querySelector('#new-knowledge')
  let input = document.querySelector('#new-knowledge-direction')
  let newKnowledgeDirectionInput = document.querySelector('#add-new-knowledge-direction')

  if (!inputGroup) return

  document.querySelector('#add-new-knowledge-direction').addEventListener('click', () => {
    if (!input.value.length) return
    (async () => {
      let response = await createKnowledgeDirection(input.value)
      response = await response.json()
      if (response.errors) {
        showAlert({messages: response.errors, type: 'danger'})
      } else {
        response.object['normalizedName'] = normalizeText(response.object.name)
        document.querySelector('#knowledge-direction-items').insertAdjacentHTML('afterbegin',
          Mustache.render(_li_knowledge_direction, response.object)
        )
        listenDirectionInsertToTable(
          document.querySelector(`#knowledge-direction-items [data-id="${response.object.id}"]`)
        )

        newKnowledgeInput.dataset.name = newKnowledgeInput.value
        newKnowledgeInput.dataset.knowledge_direction_id = response.object.id
        insertToTable(newKnowledgeInput)
        input.value = ''
        newKnowledgeInput.value = ''
        clearInputStates(input)
        clearInputStates(newKnowledgeInput)
        document.querySelector('#new-knowledge-direction-input-group').classList.add('hidden')
        document.querySelector('#new-knowledge-input-group').classList.remove('hidden')
      }
    })()
  })

  document.querySelector('#back-to-new-knowledge').addEventListener('click', () => {
    let newKnowledgeInput = document.querySelector('#new-knowledge')
    if (!newKnowledgeInput) return

    document.querySelector('#new-knowledge-direction-input-group').classList.add('hidden')
    document.querySelector('#new-knowledge-input-group').classList.remove('hidden')
  })

})

function listenDirectionInsertToTable(element) {
  element.addEventListener('click', () => {
    let newKnowledgeInput = document.querySelector('#new-knowledge')
    if (!newKnowledgeInput) return
    if (totalKnowledgePercent() >= 100) return

    newKnowledgeInput.dataset.name = newKnowledgeInput.value
    newKnowledgeInput.dataset.knowledge_direction_id = element.dataset.id
    insertToTable(newKnowledgeInput)
    newKnowledgeInput.value = ''
    clearInputStates(newKnowledgeInput)
    document.querySelector('#new-knowledge-direction-input-group').classList.add('hidden')
    document.querySelector('#new-knowledge-input-group').classList.remove('hidden')
  })
}
document.addEventListener('turbolinks:load', () => {
  /**
   * Knowledge's Directions from List To Table
   */
  document.querySelectorAll(
    '#knowledge-direction-items .knowledge-direction-item'
  ).forEach((item) => { listenDirectionInsertToTable(item) })

  /**
   * Knowledges from Table to List
   */
  document.querySelectorAll(
    'tbody.course-knowledge-items .course-knowledge-item'
  ).forEach((item) => {
    listenInputValueLimit(item)
    listenMarkedForDestruction(item)
  })

  /**
   * Knowledge from List to Table
   */
  document.querySelectorAll('#knowledge-items .knowledge-item').forEach((item) => {
    listenInsertToTable(item)
  })

  /**
   * Knowledge from Input to Table
   */
  let newKnowledgeInput = document.querySelector('#new-knowledge')
  if (!newKnowledgeInput) return

  let buttonMoveToDirections = document.querySelector('#move-to-knowledge-directions')
  if (!newKnowledgeInput) return

  buttonMoveToDirections.addEventListener('click', () => {
    if (totalKnowledgePercent() >= 100) return 
    if (newKnowledgeInput.value.length < 3) return

    document.querySelector('#new-knowledge-input-group').classList.add('hidden')
    document.querySelector('#new-knowledge-direction-input-group').classList.remove('hidden')
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
    knowledge_direction_id: knowledge.dataset.knowledge_direction_id,
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
    disableNewKnowledgeInput()
  } else {
    totalPercent.classList.remove('text-danger')
    enableNewKnowledgeInput()
  }
}

function enableNewKnowledgeInput() {
  document.querySelector('#move-to-knowledge-directions').classList.remove('disabled-element')
  document.querySelector('#new-knowledge').classList.remove('disabled-element')
}

function disableNewKnowledgeInput() {
  document.querySelector('#move-to-knowledge-directions').classList.add('disabled-element')
  document.querySelector('#new-knowledge').classList.add('disabled-element')
}

let totalKnowledgePercent = () => {
  let accum = 0
  document.querySelectorAll(
    'tr.course-knowledge-item[data-checked-for-destruction="false"] input.percent'
  ).forEach((percentInput) => { accum += parseInt(percentInput.value) })
  return accum
}
