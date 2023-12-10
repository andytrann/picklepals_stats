class PlayerRating < ApplicationRecord
  belongs_to :player_match

  default_scope -> { order(played_at: :desc) }
  
  validates :player_match_id, presence: true
end
