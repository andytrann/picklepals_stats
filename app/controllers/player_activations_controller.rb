class PlayerActivationsController < ApplicationController
  before_action :logged_in_player, only: :update
  before_action :admin_player,     only: :update
  before_action :get_player,       only: :update

  def update
    isActive = params[:isActive]
    @player.setActive(isActive)
    if isActive
      flash[:success] = "Player reactivated"
    else
      flash[:success] = "Player deactivated"
    end
    redirect_to root_url
  end

  private
    def get_player
      @player = Player.find_by(email: params[:email])
    end
end
