module HasRemoteLinks
  extend ActiveSupport::Concern

  included do
    def remote_links
      h.remote_links([object])
    end
  end
end
