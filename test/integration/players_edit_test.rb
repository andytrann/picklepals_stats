require "test_helper"

class PlayersEditTest < ActionDispatch::IntegrationTest
  def setup
    @player = players(:andytest)
  end

  test "unsuccessful edit" do
    log_in_as(@player)
    get edit_player_path(@player)
    assert_template 'players/edit'
    patch player_path(@player), params: { player: { name: "",
                                              email: "foo@invalid",
                                              password: "foo",
                                              password_confirmation: "bar" } }
    assert_template 'players/edit'
  end

  test "successful edit with friendly forwarding" do
    get edit_player_path(@player)
    log_in_as(@player)
    assert_redirected_to edit_player_url(@player)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch player_path(@player), params: { player: { name: name,
                                              email: email,
                                              current_password: "password",
                                              password: "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @player
    @player.reload
    assert_equal name.downcase, @player.name
    assert_equal email, @player.email
  end
end
