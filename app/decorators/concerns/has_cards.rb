module HasCards
  # @params Hash
  #   @params String title
  #   @params String body
  #   @params String|Integer|Float percent
  #   @params String|Nil progress_color => any Bootstrap class color
  def progress_card(params = { title: '', body: '', percent: 0 })
    params[:progress_color] ||= 'bg-green'
    h.render partial: 'shared/cards/progress_card',
             locals: { title: params[:title],
                       body: params[:body],
                       percent: params[:percent] }
  end
end
