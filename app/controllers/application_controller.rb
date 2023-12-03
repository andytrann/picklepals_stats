class ApplicationController < ActionController::Base
  include SessionsHelper
  
  private
    # Confirms a logged-in player.
    def logged_in_player
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms an admin player.
    def admin_player
      redirect_to(root_url) unless current_player.admin?
    end
end
