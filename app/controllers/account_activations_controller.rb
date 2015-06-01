class AccountActivationsController < ApplicationController

  # "Edit" action to change the boolean 'activated'
  def edit
    user = User.find_by(email: params[:email])
    # if the user hasn't been activated yet, and they supplied the activation code
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      # use the activate method of the user class to consolidate code
      user.activate
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
