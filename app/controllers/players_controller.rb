class PlayersController < ApplicationController
  before_action :logged_in_player, only: [:edit, :update, :destroy]
  before_action :correct_player,   only: [:edit, :update]
  before_action :admin_player,     only: :destroy

  # Probably can get rid of this in the future since home page will have list of players in leaderboard
  def index
    @players = Player.paginate(page: params[:page], per_page: 30)
  end

  def show
    @player = Player.find(params[:id])
  end

  def new
    @player = Player.new
  end

  def create
    @player = Player.new(player_params)
    if @player.save
      log_in @player
      flash[:success] = "Welcome to PicklePals Stats Tracker!"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @player = Player.find(params[:id])
  end

  def update
    if @player.update(player_params)
      flash[:success] = "Profile updated"
      redirect_to @player
    else
      render 'edit'
    end
  end

  def destroy
   
  end

  private
  def player_params
    params.require(:player).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  # Before filters

    # Confirms the correct player.
    def correct_player
      @player = Player.find(params[:id])
      redirect_to(root_url) unless current_player?(@player)
    end
end
