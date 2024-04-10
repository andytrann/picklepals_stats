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

    def cur_league_creator_or_proctor_player
      player_league = current_player.player_leagues.select { |pl| pl.league_id == League.get_current_league_id}.first
      redirect_to(root_url) unless (player_league && (player_league.role_creator? || player_league.role_proctor?))
    end
end
