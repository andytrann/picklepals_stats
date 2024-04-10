class Team < ApplicationRecord
  belongs_to :player_one, class_name: "Player"
  belongs_to :player_two, class_name: "Player"
  has_many :winning_matches, class_name: "Match", foreign_key: "winning_team_id"
  has_many :losing_matches,  class_name: "Match", foreign_key: "losing_team_id"
  has_many :team_matches

  validates :player_one_id, presence: true
  validates :player_two_id, presence: true
  validate  :validate_different_players
  before_create :alphabetize_players

  scope :filter_by_player, ->(player_name) { Team.joins(:player_one, :player_two).where(player_one: {name: player_name.downcase}).or(
                                                                                  where(player_two: {name: player_name.downcase})) if player_name.present? }

  def self.find_team(player_one_name, player_two_name)
    return if player_one_name.blank? || player_two_name.blank?

    #teams are unique, so should only return one team or nil
    find_teams(player_one_name, player_two_name).first
  end

  def self.find_teams(player_one_name, player_two_name)
    teams = Team.filter_by_player(player_one_name).to_a
    if player_two_name.present?
      teams = teams.select {|team| (team.player_one.name == player_two_name.downcase ||
                                    team.player_two.name == player_two_name.downcase) }
    end
    teams
  end

  def has_player?(player)
    player_one == player || player_two == player
  end

  def get_league_wins(league_id)
    winning_matches.select { |m| m.league_id == league_id }
  end

  def get_league_losses(league_id)
    losing_matches.select { |m| m.league_id == league_id }
  end

  private
    def alphabetize_players
      player_one = Player.find(self.player_one_id)
      player_two = Player.find(self.player_two_id)
      players = [player_one, player_two]
      sorted_player_names = players.sort_by(&:name)
      self.player_one_id = sorted_player_names[0].id;
      self.player_two_id = sorted_player_names[1].id;
    end

    def validate_different_players
      if self.player_one_id == self.player_two_id
        errors.add(:player_one_id, "#{player_one.name.titleize} cannot also be Player two")
      end
    end
end
