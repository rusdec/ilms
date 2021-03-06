class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
    @user = user

    if user

      if user.admin?
        admin_abilities
      elsif user.course_master?
        course_master_abilities
      else
        user_abilities
      end

    else
      guest_abilities
    end
  end

  protected

  def guest_abilities
    can(:read, :all)
    passing_abilities
  end

  def user_abilities
    guest_abilities
    passing_abilities
    profile_abilities
  end

  def course_master_abilities
    user_abilities
    manage_courses_abilities
    author_abilities
    can([:create, :read], Course)
  end

  def admin_abilities
    course_master_abilities
    admin_panel_abilities
    can([:create, :read, :update, :delete], :all)
  end

  def admin_panel_abilities
    can :admin_panel, :all do
      user.admin?
    end
  end

  def manage_courses_abilities
    can :manage_courses, :all do
      user.admin? || user.course_master?
    end
  end

  def author_abilities
    can :author, Authorable do |any|
      any = any.object if any.decorated?
      user.author_of?(any) || user.admin?
    end
  end

  def passing_abilities
    can :passing, Passage do |passage|
      passage.user == user && !passage.unavailable?
    end

    can :publicated, Passable do |publicable|
      publicable.published? || publicable.published.nil?
    end
  end

  def profile_abilities
    can :edit_profile, User do |requested_user|
      user == requested_user
    end
  end
end
