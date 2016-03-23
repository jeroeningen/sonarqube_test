class SessionsController < ApplicationController
  skip_before_filter :authenticate

  def new
    @user = User.new
    render "new"
  end

  def create
    user = User.where(email: params[:user][:email]).first
    if user.present? && user.authenticate(params[:user][:password])
      flash[:info] = t(".succesful_logged_in")
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash[:error] = t(".invalid_username_password")
      redirect_to new_session_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:info] = t(".succesful_logged_out")
    redirect_to new_session_path
  end
end
