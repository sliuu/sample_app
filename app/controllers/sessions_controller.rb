class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])

        if user.activated?
          #this uses the log_in method provided in the helpers folder
          log_in user

          #remember method of the sessions_helper.rb in helpers folder
          #if the params (where params[:session] is a hash in its own right) is equal to 1st
          # i.e. if the checkbox was checked, remember the user (remember method), if not forget the user
          params[:session][:remember_me] == '1' ? remember(user) : forget(user)

          # takes the user to his/her profile page as default, or the original page they were
          # trying to access if that exists
          redirect_back_or user
          #rails automatically converts "user", which is a model (unlike session)
          # to user_url(user) -- the profile page
        else
          message  = "Account not activated. "
          message += "Check your email for the activation link."
          flash[:warning] = message
          redirect_to root_url
        end

    else
      #error
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    # just like login, log_out is a helper method defined in helpers/sessions...
    # only call the log_out method if the user is logged in
    log_out if logged_in?
    redirect_to root_url
  end
end
