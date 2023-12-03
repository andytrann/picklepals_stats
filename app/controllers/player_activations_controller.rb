class PlayerActivationsController < ApplicationController
  before_action :logged_in_player, only: :update
  before_action :admin_player,     only: :update

  #i don't think im doing this right..
  #find all instances of player_activation_path
  def update
    player = Player.find(params[:id])
    player.setActive(false)
    flash[:success] = "Player deactivated"
    redirect_to players_url
  end
end
