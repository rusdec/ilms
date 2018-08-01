class Status < ApplicationRecord
  def self.method_missing(method, *args, &block)
    find(method)
  end
end
