let _alert = `
<div class="row">
  <div class="col">
    <div class="alert alert-{{type}} alert-dismissible fade show" role="alert">
      {{#messages}}
        <p>{{.}}</p>
      {{/messages}}
      <button type="button" class="close" data-dismiss="alert" aria-label="Close"></button>
    </div>
  </div>
</div>`
