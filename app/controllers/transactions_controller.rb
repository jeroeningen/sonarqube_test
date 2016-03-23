class TransactionsController < ApplicationController
  def index
    @transactions = current_user.transactions    
    flash[:info] = t(".no_transactions") if @transactions.empty?
  end
end
