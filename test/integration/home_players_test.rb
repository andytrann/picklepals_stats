require "test_helper"

class HomePlayersTest < ActionDispatch::IntegrationTest
  def setup
    @admin = players(:andytest)
    @non_admin = players(:crystaltest)
  end

  test "home page includes links to each player" do
    get root_path
    assert_template 'static_pages/home'
    active_players = Player.all.select(&:active)
    active_players.each do |player|
      assert_select 'a[href=?]', player_path(player), text: player.name.titleize
    end
    inactive_player = players(:kyletest)
    assert_select 'a[href=?]', player_path(inactive_player), { count: 0, text: inactive_player.name.titleize }
  end

  test "login as andy and check for deactivate links" do
    log_in_as(@admin)
    get root_path
    assert_template 'static_pages/home'
    active_players = Player.all.select(&:active)
    first_page_of_players = active_players
    first_page_of_players.each do |player|
      assert_select 'a[href=?]', player_path(player), text: player.name.titleize
      unless player == @admin
        assert_select "form input[type='submit'][value='Deactivate']"
      end
    end
    patch player_activation_path(:id => @non_admin.id, :email => @non_admin.email, :isActive => false)
    @non_admin.reload
    assert_not @non_admin.active?
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get root_path
    assert_select 'a', text: 'Deactivate', count: 0
  end
end
