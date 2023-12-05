require "test_helper"

class TeamsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @player_one = players(:andytest)
    @player_two = players(:crystaltest)
    @player_three = players(:stevetest)
  end

  test "should post create" do
    post teams_path, params: {team: {player_one_id: @player_one.id, 
                                     player_two_id: @player_two.id} }
    assert_response :success
  end

  test "invalid submission" do
    assert_no_difference 'Team.count' do 
      post teams_path, params: {team: {player_one_id: @player_one.id, 
                                       player_two_id: nil} }
    end
  end

  test "alphabetize players on creating team" do
    post teams_path, params: {team: {player_one_id: @player_two.id, 
                                     player_two_id: @player_one.id} }
    team = assigns(:team)
    assert_equal team.player_one_id, @player_one.id

    # already alphabetized, so shouldn't need to switch players
    post teams_path, params: {team: {player_one_id: @player_one.id, 
                                     player_two_id: @player_three.id} }
    team = assigns(:team)
    assert_equal team.player_one_id, @player_one.id
  end

end
