class StaticPagesController < ApplicationController
  def home
    @players = Player.sort_by_rating(League.get_current_league_id)
  end

  def about
  end
end
