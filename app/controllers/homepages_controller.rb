class HomepagesController < ApplicationController
  def index
    @user = User.new

    # needed for the transfer form
    @bankaccounts = User.where.not(id: current_user.id).joins(:bankaccount).collect{|x| ["#{x.firstname} #{x.lastname} - #{t(".bankaccount")}: #{x.bankaccount.id}", x.bankaccount.id]}
  end
end
