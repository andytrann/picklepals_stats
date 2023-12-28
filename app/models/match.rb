class Match < ApplicationRecord
  belongs_to :winning_team,   class_name: "Team"
  belongs_to :losing_team,    class_name: "Team"
  has_many   :player_matches, dependent: :destroy
  has_many   :players, through: :player_matches
  has_many   :team_matches, dependent: :destroy
  has_many   :teams, through: :team_matches

  default_scope -> { order(played_at: :desc) }
  
  validates :winning_team_id, presence: true
  validates :losing_team_id,  presence: true
  validates :winning_team_score, presence: true, numericality: { only_integer: true}
  validates :losing_team_score,  presence: true, numericality: { only_integer: true}
  validate  :validate_score
  validate  :validate_different_teams
  validate  :validate_all_different_players

  def player_won?(player)
    return if !player.is_a?(Player) || !players.include?(player)

    winning_team.player_one == player || winning_team.player_two == player
  end

  def is_ice?
    losing_team_score == 0
  end

  def self.filter_by_players(params)
    team_ones = Team.find_teams(params[:team_one_player_one], params[:team_one_player_two])
    team_twos = Team.find_teams(params[:team_two_player_one], params[:team_two_player_two])

    where(winning_team: team_ones, losing_team: team_twos).or(where(winning_team: team_twos, losing_team: team_ones))
  end

  private
    def validate_different_teams
      if self.winning_team_id == self.losing_team_id
        errors.add(:winning_team_id, "cannot also be losing team")
      end
    end

    def validate_all_different_players
      return if !winning_team_id || !losing_team_id

      winning_team = Team.find_by(id: winning_team_id)
      losing_team = Team.find_by(id: losing_team_id)
      winning_team_player_one_id = winning_team.player_one_id
      winning_team_player_two_id = winning_team.player_two_id

      if (winning_team_player_one_id == losing_team.player_one_id || winning_team_player_one_id == losing_team.player_two_id ||
            winning_team_player_two_id == losing_team.player_one_id || winning_team_player_two_id == losing_team.player_two_id )
        errors.add(:same_player, "cannot be on winning and losing teams")
      end
    end

    def validate_score
      if !(check_win_on_eleven || check_win_by_two)
        errors.add(:score, "is not valid")
      end
    end

    def check_win_on_eleven
      winning_team_score_int = winning_team_score.to_i
      losing_team_score_int = losing_team_score.to_i

      winning_team_score_int == 11 && losing_team_score_int > -1 &&
        losing_team_score_int < 10
    end

    def check_win_by_two
      winning_team_score_int = winning_team_score.to_i
      losing_team_score_int = losing_team_score.to_i

      winning_team_score_int > 11 && losing_team_score_int > 9 &&
        winning_team_score_int - losing_team_score_int == 2
    end
end
