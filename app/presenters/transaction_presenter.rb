class TransactionPresenter < BasePresenter
  def amount
    "EUR. #{sprintf("%.2f", @model.amount)}"
  end

  def created_at
    I18n.l @model.created_at, format: :long
  end

  def foreign_bankaccount_number
    # Please note that a foreign bankaccount is not present for a 'deposit' transaction.
    if @model.foreign_bankaccount.present?
      @model.foreign_bankaccount.id
    end
  end

  def foreign_bankaccount_name
    # Please note that a foreign bankaccount is not present for a 'deposit' transaction.
    if @model.foreign_bankaccount.present?
      "#{@model.foreign_bankaccount.user.firstname} #{@model.foreign_bankaccount.user.lastname}"
    end
  end
end
