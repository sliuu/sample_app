class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

    # Confirms a logged-in user.
    # This used to be in the Users Controller, but since we'll be using it for
    # Users and for Microposts, we want it here, it is the base class of all controllers
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    
end
