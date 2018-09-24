let _tr_knowledges = `
<tr class="course-knowledge-item" data-id="{{id}}" data-name="{{knowledge.name}}" data-checked-for-destruction="false" data-percent="{{percent}}">
  <td class="text-center td-del">
    <input name="course[course_knowledges_attributes][{{key}}][_destroy]"
           value="0" type="hidden">
    <input value="1" name="course[course_knowledges_attributes][{{key}}][_destroy]"
           id="course_course_knowledges_attributes_{{key}}_destroy" type="checkbox"
           class="check-for-destruction">
  </td>
  <td class="text-right td-name">{{knowledge.name}}</td>
  <td class="td-progress-bar">
    <div class="progress progress-xs">
      <div aria-valuemax="100" aria-valuemin="0" aria-valuenow="{{percent}}"
           class="progress-bar bg-yellow" style="width: {{percent}}%">
      </div>
    </div>
  </td>
  <td class="td-percent">
    <input min="1" max="100" class="form-control percent border-0 p-0 text-center"
           value="{{percent}}" name="course[course_knowledges_attributes][{{key}}][percent]"
           id="course_course_knowledges_attributes_{{key}}_percent" type="number">
  </td>
  <input value="{{id}}" name="course[course_knowledges_attributes][{{key}}][id]" id="course_course_knowledges_attributes_{{key}}_id" type="hidden">
</tr>`
