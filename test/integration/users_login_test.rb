require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    # 'users' refers to file users.yml in tests/fixtures
    @user = users(:sliu)
  end
  
  test "login with valid information followed by logout" do
    #visit login page
    get login_path
    #attempt to log in using the user in def setup
    post login_path, session: {email: @user.email, password: 'password'}
    #use the helper method in tests/helpers to return this boolean
    assert is_logged_in?
    #make sure we are redirected to the user's profile page
    assert_redirected_to @user
    #go to the user's profile page
    follow_redirect!
    #make sure we're on the user's profile page
    assert_template 'users/show'
    #check that there are no links to login
    assert_select "a[href=?]", login_path, count:0
    #check that there are links to logout and profile
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    #logout (delete is the HTTP request)
    delete logout_path
    #make sure this boolean is false now (test/helpers)
    assert_not is_logged_in?
    #make sure we are redirected to the home page
    assert_redirected_to root_url
    #go to home
    follow_redirect!
    #make sure the login link is there, the logout and profile ones are not
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
  
  test 'login with invalid information' do
    #visit login page
    get login_path
    #verify the right address renders
    assert_template 'sessions/new'
    #invalid params hash
    post login_path, session: { email: "", password: "" }
    #verify the right address renders
    assert_template 'sessions/new'
    #make sure the flash appears
    assert_not flash.empty?
    #go to home page
    get root_path
    #make sure the flash is NOT still there
    assert flash.empty?
  end
end
