class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include ApplicationHelper

  before_filter :authenticate

  def authenticate
    if session[:user_id].blank?
      flash[:notice] = I18n.t("controllers.application.not_logged_in")
      redirect_to new_session_path
    end
  end
end
