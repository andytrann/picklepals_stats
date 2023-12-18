require "test_helper"

class MatchesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @match = matches(:matchtest)
    @admin = players(:andytest)
    @non_admin = players(:crystaltest)
  end

  test "should get rollback page" do
    log_in_as(@admin)
    get rollback_path
    assert_response :success
    assert_select "title", "Rollback | Picklepals Stats Tracker"
  end

  test "should redirect to login page if not logged in" do
    delete match_path(:id)
    assert_redirected_to login_url
  end

  test "should redirect to home page if logged in but not admin" do
    log_in_as(@non_admin)
    delete match_path(:id)
    assert_redirected_to root_url
  end

  test "destroy action should remove corresponding records for match, playermatch, teammatch, and playerrating" do
    log_in_as(@admin)
    assert_difference ->{ Match.count } => -1, ->{ PlayerMatch.count } => -4,
                      ->{ TeamMatch.count } => -2, ->{ PlayerRating.count } => -4 do
      delete match_path(:id)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should not destroy anything if not logged in" do
    assert_no_difference ['Match.count', 'PlayerMatch.count', 'TeamMatch.count', 
                          'PlayerRating.count'] do
      delete match_path(:id)
    end
  end

  test "should not destroy anything if not admin" do
    log_in_as(@non_admin)
    assert_no_difference ['Match.count', 'PlayerMatch.count', 'TeamMatch.count', 
                          'PlayerRating.count'] do
      delete match_path(:id)
    end
  end

  
end
