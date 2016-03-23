require "test_helper"

feature "Users" do
  before :each do
    @jeroen = users(:jeroen)
    @jan = users(:jan)
    @jeroen_transferring_money = users(:jeroen_transferring_money)
    # set the balance manually, because the fixtures will not do it
    @jeroen_transferring_money.bankaccount.update_attribute :balance, @jeroen_transferring_money.transactions.sum(:amount)
  end
  
  scenario "can login and logout" do
    visit root_path

    # Redirected to new sessions path
    assert_equal current_path, new_session_path

    # Use invalid password
    within ".login-form" do
      fill_in :user_email, with: @jeroen.email
      fill_in :user_password, with: "12345"
      find("[type=submit]").click
    end

    # not logged in
    within ".alert-danger" do
      assert_equal true, page.has_content?("Combinatie emailadres en wachtwoord komen niet overeen.")
    end
    refute_equal current_path, root_path

    # Use valid password
    within ".login-form" do
      fill_in :user_email, with: @jeroen.email
      fill_in :user_password, with: @default_password
      find("[type=submit]").click
    end

    # Logged in
    within ".alert-info" do
      assert_equal true, page.has_content?("U bent succesvol ingelogd.")
    end
    assert_equal current_path, root_path

    # Logout
    click_link "Uitloggen"
    within ".alert-info" do
      assert_equal true, page.has_content?("U bent succesvol uitgelogd.")
    end

    # Check if really logged out
    visit root_path
    assert_equal current_path, new_session_path
  end

  scenario "can view their account" do
    login_for_integration_tests(@jeroen.email, @default_password)
    assert_equal current_path, root_path
    within ".balance" do
      assert_equal true, page.has_content?("Uw saldo is EUR. 0.00")
    end
  end

  scenario "can add deposit when logged in" do
    login_for_integration_tests(@jeroen.email, @default_password)
    assert_equal current_path, root_path
    within ".deposit-form" do
      fill_in :user_deposit, with: "211.12"
      find("[type=submit]").click
    end

    within ".alert-info" do
      assert_equal true, page.has_content?("U heeft EUR. 211.12 gestort.")
    end
    within ".balance" do
      assert_equal true, page.has_content?("Uw saldo is EUR. 211.12")
    end
  end

  scenario "can transfer money when logged in" do
    login_for_integration_tests(@jeroen_transferring_money.email, @default_password)
    assert_equal current_path, root_path
    within ".transfer-form" do
      select @jan.bankaccount.id, from: :user_transfer_money_bankaccount_id
      fill_in :user_transfer_money_amount, with: "100.12"
      fill_in :user_transfer_money_comment, with: "Mijn commentaar"
      find("[type=submit]").click
    end

    within ".alert-info" do
      assert_equal true, page.has_content?("U heeft EUR. 100.12 overgemaakt naar bankrekening '#{@jan.bankaccount.id}' van #{@jan.firstname} #{@jan.lastname}.")
    end
    within ".balance" do
      assert_equal true, page.has_content?("Uw saldo is EUR. 99.88")
    end
  end
end
