class UsersController < ApplicationController
  def create
    flash[:info] = case
      # called without 'present' to tigger the error message if no value givven, but the button is clicked
      when params[:user][:deposit] then current_user.deposit params[:user][:deposit]
      when params[:user][:transfer_money].present? 
        then current_user.transfer_money params[:user][:transfer_money][:bankaccount_id], params[:user][:transfer_money][:amount], params[:user][:transfer_money][:comment]
    end
    redirect_to root_path
  end
end
