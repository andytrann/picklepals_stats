require "test_helper"

class PlayersShowTest < ActionDispatch::IntegrationTest
  def setup
    @admin = players(:andytest)
    @active_player = players(:crystaltest)
    @inactive_player = players(:kyletest)
  end

  test "should have correct reactivate/deactivate link on player profile page" do
    log_in_as(@admin)
    get player_path(@inactive_player)
    assert_select "form input[type='submit'][value='Reactivate']"
    assert_select "form input[type='submit'][value='Deactivate']", count: 0
    get player_path(@active_player)
    assert_select "form input[type='submit'][value='Deactivate']"
    assert_select "form input[type='submit'][value='Reactivate']", count: 0
  end

  test "should not show reactivate/deactivate links on player profile page" do
    # Not logged in
    get player_path(@inactive_player)
    assert_select "form input[type='submit'][value='Reactivate']", count: 0
    assert_select "form input[type='submit'][value='Deactivate']", count: 0
    get player_path(@active_player)
    assert_select "form input[type='submit'][value='Deactivate']", count: 0
    assert_select "form input[type='submit'][value='Reactivate']", count: 0
    # Logged in as non-admin
    log_in_as(@active_player)
    get player_path(@inactive_player)
    assert_select "form input[type='submit'][value='Reactivate']", count: 0
    assert_select "form input[type='submit'][value='Deactivate']", count: 0
    get player_path(@active_player)
    assert_select "form input[type='submit'][value='Deactivate']", count: 0
    assert_select "form input[type='submit'][value='Reactivate']", count: 0
  end
end
