class Status < ApplicationRecord
  def self.method_missing(method, *args, &block)
    find_by(name: method)
  end
end
