class PlayerRating < ApplicationRecord
  belongs_to :player_match

  validates :player_match_id, presence: true
end
