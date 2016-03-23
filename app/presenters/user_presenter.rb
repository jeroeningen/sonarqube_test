class UserPresenter < BasePresenter
  def current_balance
    "#{I18n.t(".presenters.user.your_balance")} #{@model.current_balance}"
  end
end
