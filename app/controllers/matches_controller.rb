class MatchesController < ApplicationController
  before_action :logged_in_player,                       only: [:rollback, :destroy]
  before_action :cur_league_creator_or_proctor_player,   only: [:rollback, :destroy]
  before_action :store_filter_values,                    only: :index
  before_action :validate_team_one_priority,             only: :index
  before_action :validate_players,                       only: :index
  
  def index
    if @team_one_player_one.present?
      @player = Player.find_by(name: @team_one_player_one.downcase)
    elsif @team_one_player_two.present?
      @player = Player.find_by(name: @team_one_player_two.downcase)
    end
    @all_matches = Match.filter_by_players(player_params)
    @matches = @all_matches.paginate(page: params[:page], per_page: 10)
    
    calculate_score
  end

  def show
  end

  def rollback
    @last_match = Match.select{ |m| m.league_id == League.get_current_league_id }.first
  end

  def destroy
    Match.first.destroy
    flash[:success] = "Match has been rolled back"
    redirect_to root_url
  end

  private
    def player_params
      params.slice(:team_one_player_one, :team_one_player_two, :team_two_player_one, :team_two_player_two)
    end

    def store_filter_values
      @team_one_player_one = player_params[:team_one_player_one]
      @team_one_player_two = player_params[:team_one_player_two]
      @team_two_player_one = player_params[:team_two_player_one]
      @team_two_player_two = player_params[:team_two_player_two]
    end

    def calculate_score
      if @player.present?
        wins = 0
        losses = 0
        @all_matches.each do |match|
          if match.winning_team.has_player?(@player)
            wins += 1
          else
            losses += 1
          end
        end
        @score = "#{wins} - #{losses}"
      end
    end

    def validate_team_one_priority
      if ( (player_params[:team_one_player_one].blank? && player_params[:team_one_player_two].blank?) &&
           (player_params[:team_two_player_one].present? || player_params[:team_two_player_two].present?) )
        flash[:danger] = "Fill out Team One before Team Two"
        redirect_back(fallback_location: root_path)
      end
    end

    def validate_players
      players = [player_params[:team_one_player_one], player_params[:team_one_player_two], 
                 player_params[:team_two_player_one], player_params[:team_two_player_two]].reject(&:blank?)
      if players.any?
        return if validate_unique_players(players)
        return if validate_players_exists(players)
      end
    end

    def validate_unique_players(players)
      dup = players.detect {|p| players.count(p) > 1}
      if dup.present?
        flash[:danger] = "Cannot have duplicates of same player"
        redirect_back(fallback_location: root_path)
        return
      end
    end

    def validate_players_exists(players)
      players.each do |player_name|
        player = Player.find_by(name: player_name.downcase)
        if player.blank?
          flash[:danger] = "#{player_name.titleize} does not exist"
          redirect_back(fallback_location: root_path)
          return
        end
      end
    end
end
