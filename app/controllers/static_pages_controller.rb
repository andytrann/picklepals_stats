class StaticPagesController < ApplicationController
  def home
    @players = Player.paginate(page: params[:page], per_page: 30)
  end

  def about
  end
end
