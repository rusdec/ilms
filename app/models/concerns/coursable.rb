module Coursable
  extend ActiveSupport::Concern

  included do
    # Template method
    def course; end
  end
end
