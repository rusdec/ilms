function translate(text) {
  return (gon.locale && gon.i18n && JSON.parse(gon.i18n)[gon.locale][text]) || text
}
