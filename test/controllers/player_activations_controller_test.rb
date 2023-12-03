require "test_helper"

class PlayerActivationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @player = players(:andytest)
    @other_player = players(:crystaltest)
  end

  test "should redirect patch when not logged in" do
    patch player_activation_path(:id => @player.id, :isActive => false)
    assert @player.active?
    assert_redirected_to login_url
  end

  test "should redirect patch when logged in as a non-admin" do
    log_in_as(@other_player)
    patch player_activation_path(:id => @player.id, :isActive => false)
    assert @player.active?
    assert_redirected_to root_url
  end
end
