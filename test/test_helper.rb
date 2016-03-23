ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/spec"
require "minitest/autorun"
require "minitest/rails"
require "minitest/rails/capybara"

# context method not working out-of-the-box. See: https://github.com/rspec/rspec-core/issues/145

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean
# Rails.application.load_seed

# Switch to transaction after cleanup
DatabaseCleaner.strategy = :transaction

def login_for_controller_tests(user)
  request.session[:user_id] = user.id
end

def login_for_integration_tests(email, password)
  visit new_session_path

  # Use invalid password
  within ".login-form" do
    fill_in :user_email, with: email
    fill_in :user_password, with: password
    find("[type=submit]").click
  end
end


class ActiveSupport::TestCase
  # Set the default password. Please note that this does not work for the fixtures
  def setup
    @default_password = "123456"  
  end

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
