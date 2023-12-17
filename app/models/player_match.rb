class PlayerMatch < ApplicationRecord
  belongs_to :player
  belongs_to :match
  has_one   :player_rating, dependent: :destroy

  validates :player_id, presence: true
  validates :match_id,  presence: true
end
