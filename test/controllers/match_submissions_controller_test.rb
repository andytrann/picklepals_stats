require "test_helper"

class MatchSubmissionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = players(:andytest)
    @non_admin = players(:crystaltest)
    @params = { team_one_player_one_name: "andy test", 
                team_one_player_two_name: "crystal test",
                team_two_player_one_name: "steve test",
                team_two_player_two_name: "leslie test",
                team_one_score: 11,
                team_two_score: 4 }
  end

  def reset_params_to_default
    @params = { team_one_player_one_name: "andy test", 
                team_one_player_two_name: "crystal test",
                team_two_player_one_name: "steve test",
                team_two_player_two_name: "leslie test",
                team_one_score: 11,
                team_two_score: 4 }
  end

  test "should get submit page" do
    log_in_as(@admin)
    get submit_path
    assert_response :success
    assert_select "title", "Submit Match | Picklepals Stats Tracker"
  end

  test "should not create anything if not admin " do
    assert_no_difference ['Team.count', 'Match.count', 'PlayerMatch.count', 'TeamMatch.count'] do
      post match_submissions_path, params: {match_submission: @params}
    end

    log_in_as(@non_admin)
    assert_no_difference ['Team.count', 'Match.count', 'PlayerMatch.count', 'TeamMatch.count'] do
      post match_submissions_path, params: {match_submission: @params}
    end
  end

  test "should redirect to login page if not logged in" do
    post match_submissions_path, params: {match_submission: @params}
    assert_redirected_to login_url
  end

  test "should redirect to home page if logged in but not admin" do
    log_in_as(@non_admin)
    post match_submissions_path, params: {match_submission: @params}
    assert_redirected_to root_url
  end

  test "should create two new teams, new match, four new playermatches, and two new teammatches" do
    log_in_as(@admin)
    assert_difference ->{ Team.count } => 2, ->{ Match.count } => 1, ->{ PlayerMatch.count } => 4,
                      ->{ TeamMatch.count } => 2 do
      post match_submissions_path, params: {match_submission: @params}
    end
  end

  test "valid submission should be case insensitive" do
    log_in_as(@admin)
    @params[:team_one_player_one_name] = "Andy Test"
    assert_difference ->{ Team.count } => 2, ->{ Match.count } => 1, ->{ PlayerMatch.count } => 4,
                      ->{ TeamMatch.count } => 2 do
      post match_submissions_path, params: {match_submission: @params}
    end
  end

  test "should redirect to home page" do
    log_in_as(@admin)
    post match_submissions_path, params: {match_submission: @params}
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "shouldn't create duplicate team on valid match submission" do
    log_in_as(@admin)
    @params[:team_one_player_two_name] = "steve test"
    @params[:team_two_player_one_name] = "crystal test"
    assert_difference ->{ Team.count } => 1, ->{ Match.count } => 1 do
      post match_submissions_path, params: {match_submission: @params}
    end
  end

  test "shouldn't create any new teams, matches, or playermatches on invalid match submission" do
    log_in_as(@admin)

    # All fields are empty
    assert_no_difference ['Team.count', 'Match.count', 'PlayerMatch.count', 'TeamMatch.count'] do
      @params[:team_one_player_one_name] = ""
      @params[:team_one_player_two_name] = ""
      @params[:team_two_player_one_name] = ""
      @params[:team_two_player_two_name] = ""
      @params[:team_one_score] = ""
      @params[:team_two_score] = ""
      post match_submissions_path, params: {match_submission: @params}
    end

    # Empty field for one or more names
    assert_no_difference ['Team.count', 'Match.count', 'PlayerMatch.count', 'TeamMatch.count'] do
      @params[:team_one_player_one_name] = ""
      post match_submissions_path, params: {match_submission: @params}
    end

    # Invalid player name
    assert_no_difference ['Team.count', 'Match.count', 'PlayerMatch.count', 'TeamMatch.count'] do
      reset_params_to_default
      @params[:team_one_player_one_name] = "a"
      post match_submissions_path, params: {match_submission: @params}
    end

    # Same player on both teams
    assert_no_difference ['Team.count', 'Match.count', 'PlayerMatch.count', 'TeamMatch.count'] do
      reset_params_to_default
      @params[:team_two_player_one_name] = "andy test"
      post match_submissions_path, params: {match_submission: @params}
    end

    # Same teams
    assert_no_difference ['Team.count', 'Match.count', 'PlayerMatch.count', 'TeamMatch.count'] do
      reset_params_to_default
      @params[:team_two_player_one_name] = "andy test"
      @params[:team_two_player_two_name] = "crystal test"
      post match_submissions_path, params: {match_submission: @params}
    end

    # One score field is empty
    assert_no_difference ['Team.count', 'Match.count', 'PlayerMatch.count', 'TeamMatch.count'] do
      reset_params_to_default
      @params[:team_one_score] = ""
      post match_submissions_path, params: {match_submission: @params}
    end

    # Winning score is less than 10
    assert_no_difference ['Team.count', 'Match.count', 'PlayerMatch.count', 'TeamMatch.count'] do
      reset_params_to_default
      @params[:team_one_score] = 5
      post match_submissions_path, params: {match_submission: @params}
    end

    # Winning score is more than 10 but difference is greater than 2
    assert_no_difference ['Team.count', 'Match.count', 'PlayerMatch.count', 'TeamMatch.count'] do
      reset_params_to_default
      @params[:team_one_score] = 15
      post match_submissions_path, params: {match_submission: @params}
    end

    # There is a tie
    assert_no_difference ['Team.count', 'Match.count', 'PlayerMatch.count', 'TeamMatch.count'] do
      reset_params_to_default
      @params[:team_two_score] = 11
      post match_submissions_path, params: {match_submission: @params}
    end

    # Losing score is less than 0
    assert_no_difference ['Team.count', 'Match.count', 'PlayerMatch.count', 'TeamMatch.count'] do
      reset_params_to_default
      @params[:team_two_score] = -1
      post match_submissions_path, params: {match_submission: @params}
    end

    # Both scores are negative
    assert_no_difference ['Team.count', 'Match.count', 'PlayerMatch.count', 'TeamMatch.count'] do
      reset_params_to_default
      @params[:team_one_score] = -1
      @params[:team_two_score] = -11
      post match_submissions_path, params: {match_submission: @params}
    end
  end

  test "invalid submission should render submission page again" do
    log_in_as(@admin)
    @params[:team_one_player_one_name] = ""
    post match_submissions_path, params: {match_submission: @params}
    assert_not flash.empty?
    assert_template 'match_submissions/new'
  end
end
