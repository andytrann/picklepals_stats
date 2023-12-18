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

  def self.find_team(player_one_name, player_two_name)
    if !player_one_name || !player_two_name
      return
    end

    sorted_player_names = [player_one_name, player_two_name].sort
    player_one_id = Player.find_by(name: sorted_player_names[0])
    player_two_id = Player.find_by(name: sorted_player_names[1])
    Team.find_by(player_one_id: player_one_id, player_two_id: player_two_id)
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
