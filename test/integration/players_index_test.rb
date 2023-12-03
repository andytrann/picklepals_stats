require "test_helper"

class PlayersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = players(:andytest)
    @non_admin = players(:crystaltest)
  end

  test "index including pagination" do
    #log_in_as(@player)
    get players_path
    assert_template 'players/index'
    assert_select 'div.pagination'
    Player.paginate(page: 1).each do |player|
      assert_select 'a[href=?]', player_path(player), text: player.name
    end
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get players_path
    assert_template 'players/index'
    assert_select 'div.pagination'
    first_page_of_players = Player.paginate(page: 1)
    first_page_of_players.each do |player|
      assert_select 'a[href=?]', player_path(player), text: player.name
      unless player == @admin
        assert_select 'a[href=?]', player_activation_path(player.id), text: 'deactivate'
      end
    end
    patch player_activation_path(@non_admin.id)
    @non_admin.reload
    assert_not @non_admin.active?
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get players_path
    assert_select 'a', text: 'deactivate', count: 0
  end
end
