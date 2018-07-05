function parseAjaxResponse(e) {
  return { data: e.detail[0], status: e.detail[1], response: e.detail[2] }
}
