module Mumuki::Laboratory::Controllers::DynamicErrors
  extend ActiveSupport::Concern

  included do
    unless Rails.application.config.consider_all_requests_local
      rescue_from Exception, with: :internal_server_error
      rescue_from ActionController::RoutingError, with: :not_found
    end
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from Mumukit::Auth::UnauthorizedAccessError, with: :forbidden
    rescue_from Mumukit::Auth::InvalidTokenError, with: :unauthorized
    rescue_from Mumuki::Laboratory::NotFoundError, with: :not_found
    rescue_from Mumuki::Laboratory::ForbiddenError, with: :forbidden
    rescue_from Mumuki::Laboratory::UnauthorizedError, with: :unauthorized
    rescue_from Mumuki::Laboratory::GoneError, with: :gone
    rescue_from Mumuki::Laboratory::BlockedForumError, with: :blocked_forum
    rescue_from ActiveRecord::RecordInvalid, with: :bad_record
  end

  def bad_record(exception)
    # bad records can only be produced thourgh API
    render_api_errors exception.record.errors, 400
  end

  def not_found
    render_error 'not_found', 404, formats: [:html]
  end

  def internal_server_error(exception)
    Rails.logger.error "Internal server error: #{exception} \n#{exception.backtrace.join("\n")}"
    render_error 'internal_server_error', 500
  end

  def unauthorized(exception)
    render_error 'unauthorized', 401, error_message: exception.message
  end

  def forbidden
    message = "Access to organization #{Organization.current} was forbidden to user #{current_user.uid} with permissions #{current_user.permissions.to_json}"
    Rails.logger.info message
    render_error 'forbidden', 403, locals: { explanation: :forbidden_explanation }, error_message: message
  end

  def blocked_forum
    render_error 'forbidden', 403, locals: { explanation: :blocked_forum_explanation }
  end

  def gone
    render_error 'gone', 410
  end

  def render_error(template, status, options={})
    if Mumukit::Platform.organization_mapping.path_under_namespace? request.path, 'api'
      render_api_errors [options[:error_message] || template.gsub('_', ' ')], status
    else
      render_app_errors template, options.merge(status: status).except(:error_message)
    end
  end

  private

  def render_app_errors(template, options)
    render "errors/#{template}", options
  end

  def render_api_errors(errors, status)
    render json: { errors: errors }, status: status
  end
end
