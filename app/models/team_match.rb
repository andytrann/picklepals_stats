class TeamMatch < ApplicationRecord
  belongs_to :team
  belongs_to :match

  validates :team_id,  presence: true
  validates :match_id, presence: true
end
