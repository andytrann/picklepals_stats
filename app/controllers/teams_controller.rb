class TeamsController < ApplicationController
  def create
    @team = Team.new(team_params)
    @team.save
    #Maybe flash error if team isn't valid
  end

  private
  def team_params
    params.require(:team).permit(:player_one_id, :player_two_id)
  end
end
