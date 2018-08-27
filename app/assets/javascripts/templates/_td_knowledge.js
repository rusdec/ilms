let _td_knowledge = `
<tr class="course-knowledge-item" data-id="{{id}}" data-name="{{name}}">
  <td class="text-right" style="width: 15%" id="remove-knowledge">
      {{normalizedName}}
      <i class='fas fa-minus-circle text-muted'></i>
  </td>
  <td>
    <div class="progress progress-xs">
      <div class="progress-bar bg-green" role="progressbar" style="width: 0%" aria-valuenow="0" aria-valuemin="1" aria-valuemax="100">
      </div>
    </div>
  </td>
  <td style="width: 15%">
    <input name="course[course_knowledges_attributes][0][percent]" class="form-control percent border-0 p-0 text-center" type="number" min="1" max="100">
    <input name="course[course_knowledges_attributes][0][knowledge_id]" type="hidden">
    <input name="course[course_knowledges_attributes][0][knowledge_attributes][name]" type="hidden">
  </td>
</tr>`
