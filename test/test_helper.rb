ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  
  # helper methods aren't available in tests! so we can't use the other
  # method, but we will call it a different name to avoid confusion
  # other method: logged_in in helpers/sessions_helper.
  
  # since helpers/sessions_helper isn't availabled, we also can't use the
  # current_user method defined there, so we will use 'session' which is available
  def is_logged_in?
    !session[:user_id].nil?
  end
end
