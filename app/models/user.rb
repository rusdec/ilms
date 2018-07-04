class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :courses

  validates :name, presence: true
  validates :surname, presence: true

  validates :name, length: { minimum: 2, maximum: 20 }
  validates :surname, length: { minimum: 2, maximum: 20 }

  validate :validate_type

  def admin?
    type == 'Administrator'
  end

  def course_master?
    admin? || type == 'CourseMaster'
  end

  protected

  def validate_type
    unless ['User', 'Administrator', 'CourseMaster'].include?(type)
      errors.add(:type, 'invalid role')
    end
  end
end
