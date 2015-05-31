module SessionsHelper
  #Logs in the given user
  def log_in(user)
    session[:user_id] = user.id
  end
  #These are temporary cookies (will dissappear when browser is closed)
  #They are not vulnerable to a session hijacking attack, like the cookies
  #method
  #"session[]" is provided by ruby on rails. this session that we generated is not
  
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
  
  #Remembers a user in a persistent sessions
  def remember(user)
    # remember method of the User class in user.rb
    user.remember
    # permamnet = 20.years.from_now because ruby is nice
    # signed encrypts the user.id to prevent stealing
    cookies.permanent.signed[:user_id] = user.id
    # calls remember_token from User class, stores it in the cookies (20yrs again)
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Returns the current logged-in user (if any)
  
  #1st Implementation:
  #Temporary sessions are secure, but we want permanence even after the user
  #closes his/her browser
  #this ensures that we don't call User.find_by multiple times on a single page
  #the "or equals" is used because if @current_user is nil, that is equivalent
  #to false in a boolean context, so User.find_by will be called
  #similar to += in java
  #def current_user
    #@current_user ||= User.find_by(id: session[:user_id])
  #end
  
  #2nd Implementation: 
  def current_user
    # First check to see if temporary session, if so, then just do what
    # we did before (user_id is an assignment in the if statement not a comparison)
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    # If not, check to see if there is a user id stored in the cookies
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      # if there is a user objected by that user id and the remember token matches the user
      if user && user.authenticated?(cookies[:remember_token])
        # log the user in, set the current user, log in a method of ??
        log_in user
        @current_user = user
      end
    end
  end
  
  #returns true if the user is logged in , false otherwise
  #allows us to change layout links depending if a user is logged in or not
  def logged_in?
    !current_user.nil?
  end
  
  #
end
