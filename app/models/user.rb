class User < ApplicationRecord
  include Rewardable
  include Educable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, AvatarUploader

  has_many :courses
  has_many :lessons
  has_many :quests
  has_many :materials
  has_many :created_badges, class_name: 'Badge'

  has_many :user_knowledges, dependent: :destroy
  has_many :knowledges, through: :user_knowledges
  has_many :knowledge_directions, through: :knowledges, source: :direction

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

  def author_of?(any)
    id == any.author.id
  end

  protected

  def validate_type
    unless Role.all.include?(type)
      errors.add(:type, "invalid.")
    end
  end
end
