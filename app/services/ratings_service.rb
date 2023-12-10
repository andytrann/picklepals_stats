require 'TrueSkill'

class RatingsService
  def self.calculate_ratings(match)
    return if !match.is_a?(Match)

    win_team = Team.find_by(id: match.winning_team_id)
    lose_team = Team.find_by(id: match.losing_team_id)
    
    teams = [[Player.find_by(id: win_team.player_one_id), Player.find_by(id: win_team.player_two_id)], 
                [Player.find_by(id: lose_team.player_one_id), Player.find_by(id: lose_team.player_two_id)]]

    teams_ratings = []
    teams.each do |team|
      ratings = []
      team.each do |player|
        if player.player_ratings.count == 0
          rating = Rating.new
        else
          player_rating = player.player_ratings.first
          rating = Rating.new(player_rating.mu, player_rating.sigma)
        end
        ratings.push(rating)
      end
      teams_ratings.push(ratings)
    end

    true_skill = g()
    true_skill.draw_probability = 0.0
    new_ratings = true_skill.transform_ratings(teams_ratings, [0, 1])
  end

  def self.exposed_rating_formatted(player)
    return if !player.is_a?(Player)
    player_rating = player.player_ratings.first
    rating = Rating.new(player_rating.mu, player_rating.sigma)
    100 + (rating.exposure * 10)
  end
end
