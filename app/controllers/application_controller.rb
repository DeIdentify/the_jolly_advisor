class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_current_user

  def authenticate_user!
    unless session.has_key?('cas_user')
      redirect_to login_users_path(was_at: request.env['PATH_INFO'])
    end
  end

  def current_user
    @current_user
  end

  def user_signed_in?
    current_user.present?
  end

  private

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def set_current_user
    if session.has_key?('cas_user')
      @current_user = User.find_or_create_by(case_id: session['cas_user'])
    end
  end
end
