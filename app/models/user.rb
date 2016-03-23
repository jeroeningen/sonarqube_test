class User < ActiveRecord::Base
  has_one :bankaccount
  has_many :transactions, through: :bankaccount

  validates :bankaccount, presence: true
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :email, presence: true, uniqueness: true
  # Code used: http://stackoverflow.com/questions/13784845/how-would-one-validate-the-format-of-an-email-field-in-activerecord
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  has_secure_password

  before_validation :new_bankaccount
  validate :password_match_password_confirmation

  # You need to reload the bankaccount to get the actual balance
  def current_balance
    "EUR. #{sprintf('%.2f', bankaccount.reload.balance)}"
  end

  def deposit amount = nil
    # if the given param is a string, convert it to an integer
    amount = amount.to_d if amount.present?
    # check if amount is positive and if it is not zero
    if amount.blank? || amount == 0
      I18n.t("activerecord.messages.models.user.zero_deposit_not_allowed")
    elsif amount < 0
      I18n.t("activerecord.messages.models.user.negative_deposit_not_allowed")
    else
      translated_amount = sprintf('%.2f', amount)
      Transaction.create(bankaccount_id: bankaccount.id, amount: amount, 
        comment: I18n.t("activerecord.messages.models.user.deposit", amount: translated_amount))
      I18n.t("activerecord.messages.models.user.deposit_added", amount: translated_amount)
    end
  end

  def transfer_money bankaccount_id, amount, comment
    # if the given param is a string, convert it to an integer
    amount = amount.to_d if amount.present?
    # check if bankaccount is given
    if bankaccount_id.blank?
      I18n.t("activerecord.messages.models.user.no_bankaccount")
    # check if amount is positive
    elsif amount.blank? || amount == 0
      I18n.t("activerecord.messages.models.user.zero_transfer_not_allowed")
    elsif amount < 0
      I18n.t("activerecord.messages.models.user.negative_transfer_not_allowed")
    # check if amount is greater than balance
    elsif bankaccount.reload.balance < amount
      I18n.t("activerecord.messages.models.user.not_enough_balance")
    else
      translated_amount = sprintf('%.2f', amount)
      transferred_from = Bankaccount.find(bankaccount.id).user
      transferred_to = Bankaccount.find(bankaccount_id).user
      # Transaction 'Transferred from'
      Transaction.create(bankaccount_id: bankaccount.id, foreign_bankaccount_id: bankaccount_id, amount: -amount, comment: comment)

      # Transaction 'Transferred to'
      Transaction.create(bankaccount_id: bankaccount_id, foreign_bankaccount_id: bankaccount.id, amount: amount,  comment: comment)
      I18n.t("activerecord.messages.models.user.amount_transfered", amount: translated_amount, bankaccount_id: bankaccount_id, firstname: transferred_to.firstname, lastname: transferred_to.lastname)
    end
  end

  private
  def new_bankaccount
    self.bankaccount = Bankaccount.new if self.bankaccount.blank?
    true
  end

  # I do not know why, but it looks to be that the 'password_confirmation match' from has_secure_password does not work out-of-the-box
  # That is why I added this validation
  def password_match_password_confirmation
    if password != password_confirmation
      errors.add(:password_confirmation, I18n.t(".activerecord.errors.models.user.attributes.password_confirmation"))
    end
  end
end
