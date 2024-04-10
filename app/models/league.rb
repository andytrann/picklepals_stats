class League < ApplicationRecord
  include PGEnum(status: %w[pending ongoing closed], _prefix: 'status')

  belongs_to :creator, class_name: "Player"
  has_many :player_leagues
  has_many :players, through: :player_leagues
  has_many :matches

  default_scope -> { order(created_at: :desc) }

  before_save :downcase_name
  validates :creator_id, presence: true
  validates :name, presence: true, length: { maximum: 100 }
  validates :status, inclusion: { in: statuses.keys }
  validate :validate_closed_status

  #remove this later when i fully implement league functionality
  def self.get_current_league_id
    League.first.id
  end

  private
    def downcase_name
      self.name = name.downcase
    end

    def validate_closed_status
      if self.status_closed? && self.closed_at == nil
        errors.add(:closed_at, "cannot be nil if status is closed")
      elsif (self.status_pending? || self.status_ongoing?) && self.closed_at != nil
        errors.add(:closed_at, "should be nil if status is not closed")
      end
    end
end
