class MatchesController < ApplicationController
  before_action :logged_in_player, only: [:rollback, :destroy]
  before_action :admin_player,     only: [:rollback, :destroy]
  
  def index
  end

  def show
  end

  def rollback
    @last_match = Match.first
  end

  def destroy
    Match.first.destroy
    flash[:success] = "Match has been rolled back"
    redirect_to root_url
  end
end
