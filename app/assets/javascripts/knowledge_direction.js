function createKnowledgeDirection(name) {
  if (!name) return

  return fetch(`/course_master/knowledge_directions`, {
           method: 'POST',
           headers: {
             'Accept': 'application/json',
             'Content-Type': 'application/json',
             'X-CSRF-Token': getCSRFToken()
           },
           body: JSON.stringify({name: name})
         })
}
