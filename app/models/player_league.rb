class PlayerLeague < ApplicationRecord
  include PGEnum(role: %w[creator proctor participant], _prefix: 'role')
  include PGEnum(status: %w[pending active inactive], _suffix: true)
  
  belongs_to :player
  belongs_to :league

  validates :player_id, presence: true
  validates :league_id, presence: true
  validates :role, inclusion: { in: roles.keys }
  validates :status, inclusion: { in: statuses.keys }
  validates :invited_at, presence: true
  validate :validate_creator_status

  private
  def validate_creator_status
    if(league)
      if self.role_creator?
        if league.creator != self.player
          errors.add(:player_id, "should match league's creator id")
        end
      elsif self.role_proctor? || self.role_participant?
        if league.creator == self.player
          errors.add(:player_id, "should not match league's creator id if status is not creator")
        end
      end
    end
  end
end
