require "test_helper"

feature "Transactions" do
  before :each do
    @jeroen = users(:jeroen)
    @jeroen_with_transaction = users(:jeroen_with_transaction)
  end

  scenario "can not be viewed if user is not logged in" do
    visit transactions_path

    assert_equal current_path, new_session_path

    within ".alert-warning" do
      assert_equal true, page.has_content?("U moet ingelogd zijn.")
    end
  end

  scenario "see no transaction if user is logged in and has no transaction" do
    login_for_integration_tests(@jeroen.email, @default_password)
    visit root_path

    # go to transactions
    click_link "Transacties"
    assert_equal current_path, transactions_path
    within ".alert-info" do
      assert_equal true, page.has_content?("U heeft nog geen transacties.")
    end
    click_link "Home"

    assert_equal current_path, root_path
  end

  scenario "see the transactions if user is logged in and has a transaction" do
    login_for_integration_tests(@jeroen_with_transaction.email, @default_password)
    visit root_path

    # go to transactions
    click_link "Transacties"
    assert_equal current_path, transactions_path
    within "h2" do
      assert_equal true, page.has_content?("Uw transacties")
    end
    within "table" do
      assert_equal true, page.has_content?("EUR. #{@jeroen_with_transaction.transactions.last.amount}")
    end
    click_link "Home"

    assert_equal current_path, root_path
  end
end
