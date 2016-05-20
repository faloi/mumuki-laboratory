class OfflineMode

  def set_auth_provider(omniauth)
    omniauth.provider :developer
  end

  def auth_link
    'href="auth/developer"'
  end

  def protect_from_forgery(controller)
    # not needed!
  end

  def if_online

  end

  def if_offline
    yield
  end

end
