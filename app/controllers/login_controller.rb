class LoginController < ApplicationController
  Mumukit::Login.configure_login_controller! self

  skip_before_action :verify_authenticity_token, if: lambda { Rails.env.development? }

  private

  def organization_name
    params[:organization] || super
  end

  def login_failure!
    redirect_to root_path, alert: request.params['message']
  end
end
