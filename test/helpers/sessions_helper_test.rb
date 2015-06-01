# without this, the current_user method in the sessions_helper file
# is never touched!! bad, we can't verify it's working properly

require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  # create the @user variable
  def setup
    @user = users(:sliu)
    # remember the user (current_user is defined)
    remember(@user)
  end

  test "current_user returns right user when session is nil" do
    # convention is to write expected, actual
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test "current_user returns nil when remember digest is wrong" do
    # give the user object a new remember_digest
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    # current user should return nil now
    assert_nil current_user
  end
end
