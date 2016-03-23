module ApplicationHelper
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id].present?
  end

  def current_path
    request.path
  end
end
