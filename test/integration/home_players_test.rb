require "test_helper"

class HomePlayersTest < ActionDispatch::IntegrationTest
  def setup
    @admin = players(:andytest)
    @non_admin = players(:crystaltest)
  end

  test "home page includes links to each player" do
    get root_path
    assert_template 'static_pages/home'
    active_players = Player.sort_by_rating(League.get_current_league_id)
    active_players.each do |player|
      assert_select 'a[href=?]', player_path(player), text: player.name.titleize
    end
    inactive_player = players(:kyletest)
    assert_select 'a[href=?]', player_path(inactive_player), { count: 0, text: inactive_player.name.titleize }
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get root_path
    assert_select 'a', text: 'Deactivate', count: 0
  end
end
