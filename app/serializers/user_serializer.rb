class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :surname, :type,
             :created_at, :updated_at, :avatar,
             :full_name, :initials

  def avatar
    { original: object.avatar.url, preview: object.avatar.preview.url }
  end

  def initials
    "#{object.name.first}#{object.surname.first}".upcase
  end

  def full_name
    "#{object.name} #{object.surname}"
  end
end
