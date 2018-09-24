function getCSRFToken() {
  return document.querySelector('meta[name="csrf-token"]').attributes.content.value
}

function getCSRFParam() {
  return document.querySelector('meta[name="csrf-param"]').attributes.content.value
}
