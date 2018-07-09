module NavbarHelper
  def navbar_link(params = {})
    params[:additional] ||= {}
    content_tag :li, class: 'nav-item' do
      concat(link_to params[:title], params[:path], params[:additional].merge(class: 'nav-link'))
    end
  end
end
