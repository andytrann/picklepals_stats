class PlayerMatch < ApplicationRecord
  belongs_to :player
  belongs_to :match
  has_many   :player_ratings

  validates :player_id, presence: true
  validates :match_id,  presence: true
end
