require "test_helper"

class PlayerMatchTest < ActiveSupport::TestCase
  def setup
    @player_match = PlayerMatch.new(player_id: players(:andytest).id,
                                    match_id: matches(:matchtest).id)
  end

  test "should be valid" do
    assert @player_match.valid?
  end

  test "should require player id" do
    @player_match.player_id = nil
    assert_not @player_match.valid?
  end

  test "should require match id" do
    @player_match.match_id = nil
    assert_not @player_match.valid?
  end
end
