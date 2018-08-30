let _td_knowledge = `
<tr class="course-knowledge-item" data-id="{{id}}" data-name="{{name}}" data-checked-for-destruction="false" data-percent="1">
  <td class="text-center remove-knowledge td-del">
    <i class='fas fa-minus-circle text-muted'></i>
  </td>
  <td class="text-right td-name">
      {{normalizedName}}
  </td>
  <td class="td-progress-bar">
    <div class="progress progress-xs">
      <div class="progress-bar bg-green" role="progressbar" style="width: 1%" aria-valuenow="1" aria-valuemin="1" aria-valuemax="100">
      </div>
    </div>
  </td>
  <td class="td-percent">
    <!-- course_knowledges -->
    <input name="course[course_knowledges_attributes][{{count}}][percent]"
           class="form-control percent border-0 p-0 text-center"
           id="course_course_knowledges_attributes_{{count}}_percent"
           type="number" min="1" max="100" value="1">
      <!-- knowledge -->
      {{#id}}
        <input name="course[course_knowledges_attributes][{{count}}][knowledge_id]"
               id="course_course_knowledges_attributes_{{count}}_knowledge_id"
               type="hidden" value="{{id}}">
      {{/id}}
      {{^id}}
        <input name="course[course_knowledges_attributes][{{count}}][knowledge_attributes][name]"
               id="course_course_knowledges_attributes_{{count}}_knowledge_attributes_name"
               type="hidden" value="{{name}}">
      {{/id}}
      <!--/ knowledge -->
    <!--/ course_knowledges -->
  </td>
</tr>`
