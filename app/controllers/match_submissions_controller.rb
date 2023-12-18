class MatchSubmissionsController < ApplicationController
  before_action :logged_in_player,     only: [:new, :create]
  before_action :admin_player,         only: [:new, :create]
  before_action :downcase_names,       only: :create

  def player_names
    players = Player.search(params[:term])
    names = players.select(&:active).map(&:name)
    sorted_names = names.map(&:titleize).sort
    render json: sorted_names
  end
  
  #Bug where after invalid submission, goes to index page
  def index
    redirect_to submit_path
  end

  def new
    @match_creator = MatchCreator.new
  end
  
  def create
      @submit_attempt = true
      @match_creator = MatchCreator.new(match_submission_params)
      if @match_creator.submit
        flash[:success] = "Match submitted"
        redirect_to root_url
      else
        flash.now[:danger] = "Match not submitted"
        render 'new'
      end
  end

  private
    def match_submission_params
      params.require(:match_submission).permit( :team_one_player_one_name, 
                                                :team_one_player_two_name,
                                                :team_two_player_one_name,
                                                :team_two_player_two_name,
                                                :team_one_score,
                                                :team_two_score )
    end

    def downcase_names
      params[:match_submission][:team_one_player_one_name] = params[:match_submission][:team_one_player_one_name].downcase
      params[:match_submission][:team_one_player_two_name] = params[:match_submission][:team_one_player_two_name].downcase
      params[:match_submission][:team_two_player_one_name] = params[:match_submission][:team_two_player_one_name].downcase
      params[:match_submission][:team_two_player_two_name] = params[:match_submission][:team_two_player_two_name].downcase
    end
end
