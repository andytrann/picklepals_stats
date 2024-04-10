class Player < ApplicationRecord
  has_many :team_player_one_roles, class_name: "Team", foreign_key: "player_one_id"
  has_many :team_player_two_roles, class_name: "Team", foreign_key: "player_two_id"
  has_many :player_matches
  has_many :matches, through: :player_matches
  has_many :player_ratings, through: :player_matches
  has_many :player_leagues
  has_many :leagues, through: :player_leagues

  attr_accessor :remember_token, :reset_token
  before_save :downcase_name
  before_save :downcase_email
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Returns the hash digest of the given string.
  def Player.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def Player.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a player in the database for use in persistent sessions.
  def remember
    self.remember_token = Player.new_token
    update_attribute(:remember_digest, Player.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a player.
  def forget
    update_attribute(:remember_digest, nil)
  end

  def setActive(isActive = true)
    update_attribute(:active, isActive)
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = Player.new_token
    update_columns(reset_digest: Player.digest(reset_token), 
                   reset_sent_at: Time.now.utc)
  end

  # Sends password reset email.
  def send_password_reset_email
    PlayerMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def won_matches(league_id)
    sum = 0
    team_player_one_roles.each do |team|
      sum += team.get_league_wins(league_id).count
    end
    team_player_two_roles.each do |team|
      sum += team.get_league_wins(league_id).count
    end
    sum
  end

  def lost_matches(league_id)
    sum = 0
    team_player_one_roles.each do |team|
      sum += team.get_league_losses(league_id).count
    end
    team_player_two_roles.each do |team|
      sum += team.get_league_losses(league_id).count
    end
    sum
  end

  def get_rating
    RatingsService.exposed_rating_formatted(self, League.get_current_league_id)
  end

  def get_league_ratings(league_id)
    player_ratings.select { |pr| pr.player_match.match.league_id == league_id }
  end

  def self.sort_by_rating(league_id)
    players = Player.all.select(&:active?).sort_by(&:get_rating).reverse
    league = League.find(league_id)
    players.select{ |p| p.leagues.include? league }
  end

  def rating_gained(match)
    return if !match.is_a?(Match)

    league_matches = matches.select { |m| m.league_id == match.league_id}
    match_index = league_matches.find_index(match)
    return if match_index.nil?

    player_match = player_matches.find_by(match: match)
    league_ratings = get_league_ratings(match.league_id)
    player_rating = league_ratings.select { |pr| pr.player_match == player_match}.first
    rating = Rating.new(player_rating.mu, player_rating.sigma)

    if match_index == league_matches.count - 1
      previous_rating = Rating.new
    else
      previous_match = league_matches[match_index + 1]
      previous_player_match = player_matches.find_by(match: previous_match)
      previous_player_rating = league_ratings.select { |pr| pr.player_match == previous_player_match}.first
      previous_rating = Rating.new(previous_player_rating.mu, previous_player_rating.sigma)
    end

    RatingsService.exposed_rating_formatted(rating, match.league_id) - RatingsService.exposed_rating_formatted(previous_rating, match.league_id)
  end

  def self.search(term)
    where("name ILIKE ?", "%#{term}%")
  end

  private
    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    def downcase_name
      self.name = name.downcase
    end
end
