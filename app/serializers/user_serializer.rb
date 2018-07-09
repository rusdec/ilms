class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :surname, :type, :created_at, :updated_at
end
