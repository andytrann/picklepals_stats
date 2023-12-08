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
        team_one = get_team(@team_one_player_one_name, @team_one_player_two_name)
        team_two = get_team(@team_two_player_one_name, @team_two_player_two_name)
        return unless team_one && team_two

        team_one_score_int = @team_one_score.to_i
        team_two_score_int = @team_two_score.to_i
        
        if team_one_score_int > team_two_score_int
          winning_team = team_one
          winning_score = @team_one_score.to_i
          losing_team = team_two
          losing_score = @team_two_score.to_i
        else
          winning_team = team_two
          winning_score = @team_two_score.to_i
          losing_team = team_one
          losing_score = @team_one_score.to_i
        end

        match = Match.new(winning_team_id: winning_team.id, losing_team_id: losing_team.id,
                          winning_team_score: winning_score, losing_team_score: losing_score,
                          played_at: Time.now.utc)
        return unless match.save!
        
        true
      end
    rescue ActiveRecord::RecordInvalid => e
      @errors << e.message
      false
    rescue # it'll go here if cannot find player in DB. custom error messages added in get_team function
    end
  end
  private
    def get_team(player_one_name, player_two_name)
      team = Team.find_team(player_one_name, player_two_name)
      if !team
        player_one = Player.find_by(name: player_one_name)
        player_two = Player.find_by(name: player_two_name)

        @errors << "Validation failed: #{player_one_name} is not a registered player" if player_one.nil?
        @errors << "Validation failed: #{player_two_name} is not a registered player" if player_two.nil?

        team = Team.new(player_one_id: player_one.id, player_two_id: player_two.id)
        if team.save!
          team
        else
        end
      else
        team
      end
    end
end

    # 1) Match info gets submitted from form
    # 2) Grabs team IDs from inputed names,
    #    if no team, create record in Team table and store ID
    # 3) Create record in Match table with team IDs
    # 4) Create record in PlayerMatch table
    # 5) Create record in TeamMatch table
