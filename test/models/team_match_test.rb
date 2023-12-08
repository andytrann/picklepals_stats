require "test_helper"

class TeamMatchTest < ActiveSupport::TestCase
  def setup
    @team_match = TeamMatch.new(team_id: teams(:al).id,
                                  match_id: matches(:matchtest).id)
  end

  test "should be valid" do
    assert @team_match.valid?
  end

  test "should require team id" do
    @team_match.team_id = nil
    assert_not @team_match.valid?
  end

  test "should require match id" do
    @team_match.match_id = nil
    assert_not @team_match.valid?
  end
end
