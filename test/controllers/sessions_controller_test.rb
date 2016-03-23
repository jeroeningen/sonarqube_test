require "test_helper"

describe SessionsController do

  context "new session" do
    it "new" do
      get :new
      assert_template :new
    end
  end

  context "create a session" do
    before(:each) do
      @jeroen = users(:jeroen)
    end
    it "fails to log in" do
      post :create, user: {email: @jeroen.email, password: "12345"}
      assert_redirected_to new_session_path
      assert_equal true, request.session[:user_id].blank?
    end
    it "logging in successful" do
      post :create, user: {email: @jeroen.email, password: @default_password, password_confimation: @default_password}
      assert_redirected_to root_path
      assert_equal true, request.session[:user_id].present?
    end
    it "logout" do
      login_for_controller_tests @jeroen
      get :destroy
      assert_redirected_to new_session_path
      assert_equal true, request.session[:user_id].blank?
    end
  end
end
