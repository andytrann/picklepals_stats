require "test_helper"

class TeamTest < ActiveSupport::TestCase
  def setup
    @team = Team.new(player_one_id: players(:andytest).id,
                     player_two_id: players(:crystaltest).id)
  end

  test "should be valid" do
    assert @team.valid?
  end

  test "should require player one" do
    @team.player_one_id = nil
    assert_not @team.valid?
  end

  test "should require player two" do
    @team.player_two_id = nil
    assert_not @team.valid?
  end

  test "should require two unique players" do
    @team.player_two_id = @team.player_one_id
    assert_not @team.valid?
  end

  test "should alphabetize players on creating team " do
    @team.player_one_id = players(:leslietest).id
    @team.save
    @team.reload
    assert @team.player_one_id = players(:crystaltest).id
    assert @team.player_two_id = players(:leslietest).id
  end
end
