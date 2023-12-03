require "test_helper"

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @player = players(:andytest)
  end

  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    assert_select 'input[name=?]', 'password_reset[email]'
    # Invalid email
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # Valid email
    post password_resets_path,
        params: { password_reset: { email: @player.email } }
    assert_not_equal @player.reset_digest, @player.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # Password reset form
    player = assigns(:player)
    # Wrong email
    get edit_password_reset_path(player.reset_token, email: "")
    assert_redirected_to root_url
    # Inactive player
    #player.toggle!(:activated)
    #get edit_password_reset_path(player.reset_token, email: player.email)
    #assert_redirected_to root_url
    #player.toggle!(:activated)
    # Right email, wrong token
    get edit_password_reset_path('wrong token', email: player.email)
    assert_redirected_to root_url
    # Right email, right token
    get edit_password_reset_path(player.reset_token, email: player.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", player.email
    # Invalid password & confirmation
    patch password_reset_path(player.reset_token),
          params: { email: player.email,
                    player: { password: "foobaz",
                            password_confirmation: "barquux" } }
    assert_select 'div#error_explanation'
    # Empty password
    patch password_reset_path(player.reset_token),
          params: { email: player.email,
                    player: { password: "",
                            password_confirmation: "" } }
    assert_select 'div#error_explanation'
    # Valid password & confirmation
    patch password_reset_path(player.reset_token),
          params: { email: player.email,
                    player: { password: "foobaz",
                            password_confirmation: "foobaz" } }
    assert_nil @player.reload.reset_digest
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to player
  end

  test "expired token" do
    get new_password_reset_path
    post password_resets_path,
        params: { password_reset: { email: @player.email } }

    @player = assigns(:player)
    @player.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@player.reset_token),
          params: { email: @player.email,
                    player: { password: "foobar",
                            password_confirmation: "foobar" } }
    assert_response :redirect
    follow_redirect!
    assert_match "expired", response.body.downcase
  end
end
