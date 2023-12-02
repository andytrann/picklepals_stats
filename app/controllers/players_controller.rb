class PlayersController < ApplicationController
  def index
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
      flash[:success] = "Welcome to PicklePals Stats!"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def player_params
    params.require(:player).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
