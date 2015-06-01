ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Returns true if the user is logged in

  # helper methods aren't available in tests! so we can't use the other
  # method, but we will call it a different name to avoid confusion
  # other method: logged_in in helpers/sessions_helper.

  # since helpers/sessions_helper isn't availabled, we also can't use the
  # current_user method defined there, so we will use 'session' which is available
  def is_logged_in?
    !session[:user_id].nil?
  end

  # Logs in a test user

  # This helper method will be used for testing the checkbox
  def log_in_as(user, options = {})
    password = options[:password] || 'password'
    remember_me = options[:remember_me] || '1'
    # in integration tests, we can post to the sessions path,
    # but in other tests we won't be able to, so we need to check
    if integration_test?
      # create a user
      post login_path, session: {email: user.email,
                                  password: password,
                                  remember_me: remember_me}
    else
      # if not in integration test, then we need to manipulate the session method
      # directly (not really sure)
      session[:user_id] = user.id
    end
  end

  private

    # Returns true inside an integration test
    def integration_test?
      # checks for the existance of a method only found in integration tests
      defined?(post_via_redirect)
    end

end
