class StaticPagesController < ApplicationController
  def home
    @players = Player.sort_by_rating
  end

  def about
  end
end
