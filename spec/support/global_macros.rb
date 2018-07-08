module GlobalMacros
  def roles
    Role.all
  end

  def manage_roles
    Role.all.reject { |role| role == 'User' }
  end

  def non_manage_roles
    ['User']
  end

  def non_admin_roles
    Role.all.reject { |role| role == 'Administrator' }
  end
end
