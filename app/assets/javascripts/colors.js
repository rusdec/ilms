function removeColors(element) {
  for(i = 0; i < element.classList.length; i++) {
    if (/^bg-[a-z\-]+$/.test(element.classList[i])) {
      element.classList.remove(element.classList[i])
    }
  }
  return element
}

