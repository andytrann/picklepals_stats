class PlayerActivationsController < ApplicationController
  before_action :logged_in_player, only: :update
  before_action :admin_player,     only: :update
  before_action :get_player,       only: :update

  def update
    @player.setActive(params[:isActive])
    flash[:success] = "Player deactivated"
    redirect_to players_url
  end

  private
    def get_player
      @player = Player.find_by(email: params[:email])
    end
end
