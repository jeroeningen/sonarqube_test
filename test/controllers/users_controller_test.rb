require "test_helper"

describe UsersController do

  context "without login" do
    it "cannot access the create action" do
      post :create
      assert_redirected_to new_session_path
    end
    it "cannot create a deposit" do
      post :create, user: {deposit: "70.21"}
      assert_redirected_to new_session_path
    end
    it "cannot create a money transfer" do
      @jan = User.where(email: "jandevries@gmail.com").first
      post :create, user: {transfer_money: {bank_account_id: @jan.bankaccount.id, amount: "70.21"}}
      assert_redirected_to new_session_path
    end
  end

  # Please note that the login-method should be put in a before-each loop. This is not done, because it was called also for the other context
  context "with login" do
    before :each do
      @jeroen = users(:jeroen)
      @jan = users(:jan)
    end
    it "creates a deposit" do
      login_for_controller_tests @jeroen
      post :create, user: {deposit: "70.21"}
      assert_redirected_to root_path
    end
    it "creates a money transfer" do
      login_for_controller_tests @jeroen
      post :create, user: {transfer_money: {bank_account_id: @jan.bankaccount.id, amount: "70.21"}}
      assert_redirected_to root_path
    end
  end
end
