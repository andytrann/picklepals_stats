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

  def self.exposed_rating_formatted(player_or_rating)
    if player_or_rating.is_a?(Player)
      player_rating = player_or_rating.player_ratings.first
      if player_rating.nil?
        rating = Rating.new
      else
        rating = Rating.new(player_rating.mu, player_rating.sigma)
      end
      100 + (rating.exposure * 10)
    elsif player_or_rating.is_a?(Rating)
      100 + (player_or_rating.exposure * 10)
    end
  end

  def self.get_player_rank(player, players)
    return if player.nil?
    index = players.find_index(player)
    return if index.nil?
    if index == 0
      index + 1
    elsif index == 1
      exposed_player_rating = exposed_rating_formatted(player)
      exposed_previous_player_rating = exposed_rating_formatted(players[index - 1])
      if (exposed_player_rating - exposed_previous_player_rating).abs <= 0.00001
        index
      else
        index + 1
      end
    else
      exposed_player_rating = exposed_rating_formatted(player)
      exposed_previous_player_rating = exposed_rating_formatted(players[index - 1])
      while (index >= 1 && (exposed_player_rating - exposed_previous_player_rating).abs <= 0.00001)
        index -= 1
        exposed_previous_player_rating = exposed_rating_formatted(players[index - 1])
      end
      index + 1
    end
  end
end
