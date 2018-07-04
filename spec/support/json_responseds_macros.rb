module JsonResponsedMacros
  def json_success_hash
    { status: true, message: 'Success' }
  end

  def json_access_denied_hash
    { status: false, errors: ['You are not authorized to access this page.'] }
  end
end
