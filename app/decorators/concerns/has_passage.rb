module HasPassage
  def learn_now(current_user = nil)
    return unless current_user

    if current_user.passages.in_progress?(self)
      return h.button_tag 'You learning it',  class: 'btn btn-outline-primary',
                                            disabled: true
    end

    h.form_for [:learn, self], { remote: true, format: :json, method: :post } do |f|
      h.concat(f.hidden_field :id, value: self.id)
      h.concat(f.submit 'Learn now!', class: 'btn btn-primary')
    end
  end
end
