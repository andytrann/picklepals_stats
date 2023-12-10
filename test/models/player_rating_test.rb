require "test_helper"

class PlayerRatingTest < ActiveSupport::TestCase
  def setup
    @player_rating = PlayerRating.new(player_match_id: player_matches(:andy).id,
                                      mu: 25.0,
                                      sigma: (25.0/3.0),
                                      played_at: matches(:matchtest).played_at)
  end

  test "should be valid" do
    assert @player_rating.valid?
  end

  test "should require player match id" do
    @player_rating.player_match_id = nil
    assert_not @player_rating.valid?
  end
end
