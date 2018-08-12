# todo: What about using enum?
class Status < ApplicationRecord
  def self.method_missing(method, *args, &block)
    find_by(name: method)
  end
end
