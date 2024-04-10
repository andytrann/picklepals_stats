require "test_helper"

class MatchTest < ActiveSupport::TestCase
  def setup
    @match = Match.new(winning_team_id: teams(:al).id, 
                       losing_team_id:  teams(:cs).id, 
                       winning_team_score: 11,
                       losing_team_score:  2,
                       league_id: leagues(:leaguetest).id)
  end

  test "should be valid" do
    assert @match.valid?
  end

  test "should require winning team to be valid" do
    @match.winning_team_id = nil
    assert_not @match.valid?
  end

  test "should require losing team to be valid" do
    @match.losing_team_id = nil
    assert_not @match.valid?
  end

  test "should require all players to be different" do
    @match.losing_team_id = teams(:as).id
    assert_not @match.valid?
  end

  test "should require winning score to be greater than losing score" do
    @match.losing_team_score = 13
    assert_not @match.valid?
  end

  test "losing score should be between 0 and 9 if winning score is 11" do
    @match.losing_team_score = 10
    assert_not @match.valid?
    @match.losing_team_score = -1
    assert_not @match.valid?
  end

  test "score difference should be 2 if winning score is > 11" do
    @match.winning_team_score = 15
    assert_not @match.valid?
    @match.losing_team_score = 13
    assert @match.valid?
  end

  test "deleting match should remove corresponding records for playermatch, teammatch, and playerrating" do
    match = matches(:matchtest)
    assert_difference ->{ Match.count } => -1, ->{ PlayerMatch.count } => -4,
                      ->{ TeamMatch.count } => -2, ->{ PlayerRating.count } => -4 do
      match.destroy
    end
  end
end
