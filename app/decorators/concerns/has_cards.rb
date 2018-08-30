module HasCards
  # @params Hash
  #   @params String title
  #   @params String body
  #   @params String|Integer|Float percent
  #   @params String|Nil progress_color => any Bootstrap class color: bg-green, bg-red, etc
  def progress_card(params = { title: '', body: '', percent: 0 })
    params[:progress_color] ||= h.progress_color(params[:percent])
    h.render partial: 'shared/cards/progress_card', locals: params
  end
end
