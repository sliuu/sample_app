class UsersController < ApplicationController

  # Don't allow all users to be able to access all pages!
  # Random updating of different users info!?
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    # The paginate method will pull users out of the database 30 (by default) at a time
    # Depending on what page # is given, will pull out 31-60, or... etc
    # Here, params[:page] is used because it is generated automatically by will_paginate
    @users = User.paginate(page: params[:page])
  end

  def destroy
    # ooh chaining!!
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # Handle a successful save
      # using the send_activation_email method of the USER class
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  # Allow the user to edit info
  def edit
    # @user = User.find(params[:id]) -- not needed bc of correct_user
  end

  # Just like the create method, if invalid info is given, we stay on the edit page
  def update
    # @user = User.find(params[:id]) -- not needed bc of correct_user

    if @user.update_attributes(user_params)
      # update worked? send a flash message, go to profile page
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                      :password_confirmation)
    end


    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      # Because correct_user assign @user we can simplify code
      redirect_to(root_url) unless current_user?(@user)
      # current_user? method of sessions helpers
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
