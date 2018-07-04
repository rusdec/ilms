module GlobalMacros
  def roles
    ['User', 'Administrator', 'CourseMaster']
  end

  def manage_roles
    ['Administrator', 'CourseMaster']
  end

  def non_manage_roles
    ['User']
  end
end
