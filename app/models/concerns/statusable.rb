module Statusable
  extend ActiveSupport::Concern

  included do
    belongs_to :status
  end
end
