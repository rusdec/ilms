let radio_quest_groups_template = `
{{#quest_groups}}
<div class="form-check">
  {{#current_quest_group}}
  <input class="form-check-input" name="quest[quest_group_id]" id="quest_quest_group_id_{{ id }}" type="radio" value="{{ id }}" checked="checked">
  {{/current_quest_group}}
  {{^current_quest_group}}
  <input class="form-check-input" name="quest[quest_group_id]" id="quest_quest_group_id_{{ id }}" type="radio" value="{{ id }}">
  {{/current_quest_group}}
  {{#quests}}
    {{#title}}
    <a href=''>{{ title }}</a>
    {{/title}}
  {{/quests}}
  {{^quests}}
  <span>none</span>
  {{/quests}}
</div>
{{/quest_groups}}`
