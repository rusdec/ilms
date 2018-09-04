function addInputState(input, state) {
  if (!input || !state) return
  clearInputStates(input)
  input.classList.add(state)
}

function removeInputState(input, state) {
  if (!input || !state) return
  input.classList.remove(state)
}

function clearInputStates(input) {
  if (!input) return
  Array.from(input.classList).filter((classItem) => {
    if (classItem.match(/^state-/)) input.classList.remove(classItem)
  })
}

let inputStateInvalid = (input) => { addInputState(input, 'state-invalid') }
let inputStateValid = (input) => { addInputState(input, 'state-valid') }

function inputListenMaxMinValues(params) {
  if (!params.input || !params.min || !params.max) return

  params.input.addEventListener('input', () => {
    if (params.input.value.length == 0) {
      clearInputStates(params.input)
      return
    }

    if (params.input.value.length < params.min || params.input.value.length > params.max) {
      inputStateInvalid(params.input)
      return
    }

    inputStateValid(params.input)
  })
}
