class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      #Log the user in, redirect to the user's profile page
      
      #this uses the log_in method provided in the helpers folder
      log_in user
      
      #remember method of the sessions_helper.rb in helpers folder
      remember user
      
      #takes the user to his/her profile page
      redirect_to user
      #rails automatically converts "user", which is a model (unlike session)
      # to user_url(user) -- the profile page
    
    else
      #error
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy 
    # just like login, log_out is a helper method defined in helpers/sessions...
    log_out
    redirect_to root_url
  end
end
