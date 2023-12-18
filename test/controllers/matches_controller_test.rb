require "test_helper"

class MatchesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @match = matches(:matchtest)
  end

  test "destroy action should remove corresponding records for match, playermatch, teammatch, and playerrating" do
    assert_difference ->{ Match.count } => -1, ->{ PlayerMatch.count } => -4,
                      ->{ TeamMatch.count } => -2, ->{ PlayerRating.count } => -4 do
      delete match_path(:id)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end
end
