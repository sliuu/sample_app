require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
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

  test "valid signup information" do
    # go to signup page
    get signup_path
    # ensure that the user count has been increased by 1 after creating a valid user
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name: "Example User",
                                            email: "user@example.com",
                                            password: "password",
                                            password_confirmation: "password" }
    end
    # ensure redirected to profile page
    #assert_template 'users/show'
    # using the method created in test/helpers (other helpers not available in tests)
    #assert is_logged_in?
  end

end

#assert_no_difference checks user count before and after "do", and
#makes sure the two are equal
