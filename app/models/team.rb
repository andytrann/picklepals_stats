class Team < ApplicationRecord
  belongs_to :player_one, class_name: "Player"
  belongs_to :player_two, class_name: "Player"

  validates :player_one_id, presence: true
  validates :player_two_id, presence: true
  validate :check_same_player
  before_create :alphabetize_players

  private
    def alphabetize_players
      player_one = Player.find(self.player_one_id)
      player_two = Player.find(self.player_two_id)
      players = [player_one, player_two]
      sortedPlayers = players.sort_by(&:name)
      self.player_one_id = sortedPlayers[0].id;
      self.player_two_id = sortedPlayers[1].id;
    end

    def check_same_player
      errors.add(:player_one_id, "Team cannot consist of two of the same players") if self.player_one_id == self.player_two_id
    end
end
