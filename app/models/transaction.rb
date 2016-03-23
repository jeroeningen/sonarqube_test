class Transaction < ActiveRecord::Base
  belongs_to :bankaccount
  belongs_to :foreign_bankaccount, class_name: "Bankaccount"

  validates :amount, presence: true

  validate :amount_may_not_be_zero

  after_save :update_balance

  private

  def update_balance
    bankaccount.update_attribute :balance, bankaccount.transactions.sum(:amount)
  end

  def amount_may_not_be_zero
    if amount == 0.0
      errors.add(:amount, I18n.t(".activerecord.errors.models.transaction.attributes.amount"))
    end
  end
end
