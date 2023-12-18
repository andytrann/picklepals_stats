require "test_helper"

class PlayerActivationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @player = players(:andytest)
    @other_player = players(:crystaltest)
    @inactive_player = players(:kyletest)
  end

  test "should redirect patch when not logged in" do
    patch player_activation_path(:id => @player.id, :email => @player.email, :isActive => false)
    assert @player.active?
    assert_redirected_to login_url
  end

  test "should redirect patch when logged in as a non-admin" do
    log_in_as(@other_player)
    patch player_activation_path(:id => @player.id, :email => @player.email, :isActive => false)
    assert @player.active?
    assert_redirected_to root_url
  end

  test "should reactivate an inactive player" do
    log_in_as(@player)
    assert_not @inactive_player.active?
    patch player_activation_path(:id => @inactive_player.id, :email => @inactive_player.email, :isActive => true)
    @inactive_player.reload
    assert @inactive_player.active?
    assert_redirected_to root_url
  end

  test "should deactivate an active player" do
    log_in_as(@player)
    assert @other_player.active?
    patch player_activation_path(:id => @other_player.id, :email => @other_player.email, :isActive => false)
    @other_player.reload
    assert_not @other_player.active?
    assert_redirected_to root_url
  end
end
