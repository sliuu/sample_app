require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    # reset, in case other methods use ActionMailer. We will test later that
    # exactly one message was delivered, so we need to clear
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    # after going to the signup page, attempt to add an invalid user
    # and then ensure that the user count does not change
    assert_no_difference 'User.count' do
      post users_path, user: { name:  "",
                               email: "user@invalid",
                               password:              "foo",
                               password_confirmation: "bar" }
    end
    # ensure redirected to the sign up page
    assert_template 'users/new'
  end

  test "valid signup information with account activation" do
    # go to signup page
    get signup_path
    # ensure that the user count has been increased by 1 after creating a valid user
    assert_difference 'User.count', 1 do
      post users_path, user: { name: "Example User",
                                            email: "user@example.com",
                                            password: "password",
                                            password_confirmation: "password" }
    end
    # Update for the activation token

    # Exactly 1 message was delivered
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end

end

#assert_no_difference checks user count before and after "do", and
#makes sure the two are equal
