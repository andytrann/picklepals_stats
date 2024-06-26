class PlayersController < ApplicationController
  before_action :logged_in_player,                     only: [:edit, :update, :destroy]
  before_action :correct_player,                       only: [:edit, :update]
  before_action :cur_league_creator_or_proctor_player, only: :destroy
  before_action :logged_out_player,                    only: [:new, :create]

  def show
    @players = Player.sort_by_rating(League.get_current_league_id)
    @player = Player.find(params[:id])
    @matches = @player.matches.where(league_id: League.get_current_league_id).paginate(page: params[:page], per_page: 10)
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
    if check_password?
      if @player.update(player_params)
        flash[:success] = "Profile updated"
        redirect_to @player
      else
        render 'edit'
      end
    else
      flash.now[:danger] = "Submitted password doesn't match current password"
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

  # Confirm correct current password before updating 
  def check_password?
    @player = Player.find(params[:id])
    @player.authenticate(params[:player][:current_password])
  end

  def logged_out_player
    if logged_in?
      flash[:danger] = "Cannot sign up while logged in."
      redirect_to root_url
    end
  end
end
