require "test_helper"

class HomePlayersTest < ActionDispatch::IntegrationTest
  def setup
    @admin = players(:andytest)
    @non_admin = players(:crystaltest)
  end

  test "home page includes links to each player" do
    get root_path
    assert_template 'static_pages/home'
    Player.all.each do |player|
      assert_select 'a[href=?]', player_path(player), text: player.name.capitalize
    end
  end

  test "login as andy and check for delete links" do
    log_in_as(@admin)
    get root_path
    assert_template 'static_pages/home'
    first_page_of_players = Player.all
    first_page_of_players.each do |player|
      assert_select 'a[href=?]', player_path(player), text: player.name.capitalize
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
