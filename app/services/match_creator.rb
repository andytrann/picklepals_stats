require 'TrueSkill'

class MatchCreator

  attr_reader :match, :errors

  def initialize(attributes = {})
    @team_one_player_one_name = attributes[:team_one_player_one_name]
    @team_one_player_two_name = attributes[:team_one_player_two_name]
    @team_two_player_one_name = attributes[:team_two_player_one_name]
    @team_two_player_two_name = attributes[:team_two_player_two_name]
    @team_one_score = attributes[:team_one_score]
    @team_two_score = attributes[:team_two_score]
    @errors = Array.new
  end

  def submit
    begin
      ActiveRecord::Base.transaction do 
        # Try and either get Team for DB or create new Team if doesnt exist yet
        team_one = get_team(@team_one_player_one_name, @team_one_player_two_name)
        team_two = get_team(@team_two_player_one_name, @team_two_player_two_name)
        #return unless team_one && team_two

        assign_teams_and_scores(team_one, team_two)

        # Create new Match
        match = Match.new(winning_team_id: @winning_team.id, losing_team_id: @losing_team.id,
                          winning_team_score: @winning_score, losing_team_score: @losing_score,
                          played_at: Time.now.utc)
        return unless match.save!
        
        create_player_matches(match)
        new_ratings = RatingsService.calculate_ratings(match)
        create_player_ratings(new_ratings, match)

        true
      end
    rescue => e
      @errors << e.message
      false
    end
  end

  private
    def get_team(player_one_name, player_two_name)
      team = Team.find_team(player_one_name, player_two_name)
      if !team
        player_one = Player.find_by(name: player_one_name)
        player_two = Player.find_by(name: player_two_name)
        
        raise ActiveRecord::RecordNotFound.new "Validation failed: #{player_one_name.titleize} is not a registered player" if player_one.nil?
        raise ActiveRecord::RecordNotFound.new "Validation failed: #{player_two_name.titleize} is not a registered player" if player_two.nil?
        
        raise ActiveRecord::RecordNotFound.new "Validation failed: #{player_one_name.titleize} is currently not an active player" if !player_one.active?
        raise ActiveRecord::RecordNotFound.new "Validation failed: #{player_two_name.titleize} is currently not an active player" if !player_two.active?

        team = Team.new(player_one_id: player_one.id, player_two_id: player_two.id)
        team if team.save!
      else
        team
      end
    end

    # Assign winning and losing teams and scores
    def assign_teams_and_scores(team_one, team_two)
      team_one_score_int = @team_one_score.to_i
      team_two_score_int = @team_two_score.to_i

      if team_one_score_int > team_two_score_int
        @winning_team = team_one
        @winning_score = @team_one_score.to_i
        @losing_team = team_two
        @losing_score = @team_two_score.to_i
      else
        @winning_team = team_two
        @winning_score = @team_two_score.to_i
        @losing_team = team_one
        @losing_score = @team_one_score.to_i
      end
    end

    # Create PlayerMatch record for each player and TeamMatch record for each new team
    def create_player_matches(match)
      teams = [Team.find_by(id: match.winning_team_id), Team.find_by(id: match.losing_team_id)]
      teams.each do |team|
        team_match = TeamMatch.new(team_id: team.id, match_id: match.id)
        return unless team_match.save!

        player_ids = [team.player_one_id, team.player_two_id]
        player_ids.each do |player_id|
          player_match = PlayerMatch.new(player_id: player_id, match_id: match.id)
          return unless player_match.save!
        end
      end
    end

    # Create PlayerRating record for each player from the match
    def create_player_ratings(new_ratings, match)
      return if !match.is_a?(Match) || new_ratings.nil?

      win_team = Team.find_by(id: match.winning_team_id)
      lose_team = Team.find_by(id: match.losing_team_id)
      
      teams_players = [[Player.find_by(id: win_team.player_one_id), Player.find_by(id: win_team.player_two_id)], 
                      [Player.find_by(id: lose_team.player_one_id), Player.find_by(id: lose_team.player_two_id)]]

      teams_players.each_with_index do |team, tIndex|
        team.each_with_index do |player, pIndex|
          player_match = PlayerMatch.find_by(player_id: player.id, match_id: match.id)
          raise ActiveRecord::RecordNotFound.new "Record not found: Could not find player match record "\
                                                   " for #{player.name} for match id #{match.id}" if player_match.nil?

          rating = new_ratings[tIndex][pIndex]
          rating_parse = rating.to_s.split(',')

          mu_string = rating_parse[0][1..-1]
          mu_parse = mu_string.split('=')
          mu_f = mu_parse[1].to_f

          sigma_string = rating_parse[1].chop
          sigma_parse = sigma_string.split('=')
          sigma_f = sigma_parse[1].to_f

          player_rating = PlayerRating.new(player_match_id: player_match.id, mu: mu_f, 
                                            sigma: sigma_f, played_at: match.played_at)
          return unless player_rating.save!
        end
      end
    end
end
