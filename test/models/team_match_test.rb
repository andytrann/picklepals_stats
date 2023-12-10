require "test_helper"

class TeamMatchTest < ActiveSupport::TestCase
  def setup
    @team_match = team_matches(:al)
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
