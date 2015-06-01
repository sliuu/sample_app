require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:sliu)
  end

  test "unsuccessful edit" do
    # Only users can edit. This method is in test/test_helper.rb
    log_in_as(@user)
    # Go to edit page
    get edit_user_path(@user)
    # Make sure we're on the edit page
    assert_template 'users/edit'
    # PATCH: change the user with invalid info
    patch user_path(@user), user: { name:  "",
                                    email: "foo@invalid",
                                    password:              "foo",
                                    password_confirmation: "bar" }
    # Ensure we're still on the edit page
    assert_template 'users/edit'
  end

  # Friendly forwarding means that if the user tries to go to his edit page
  # before logging in, and then logs in, he/she is redirected to the edit page
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    # Only users can edit. This method is in test/test_helper.rb
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = "Foo Bar"
    email = "foo@bar.com"
    # Change some info, leaving passwords alone
    patch user_path(@user), user: { name:  name,
                                    email: email,
                                    password:              "",
                                    password_confirmation: "" }
    # Flash messages are present
    assert_not flash.empty?
    # Went to profile page
    assert_redirected_to @user
    # Ask the database to reload the user
    @user.reload
    # Ensure the new name and the new email are in the database
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end


end
