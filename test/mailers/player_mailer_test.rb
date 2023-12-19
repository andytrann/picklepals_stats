require "test_helper"

class PlayerMailerTest < ActionMailer::TestCase
  test "password_reset" do
    player = players(:andytest)
    player.reset_token = Player.new_token
    mail = PlayerMailer.password_reset(player)
    assert_equal "Password reset", mail.subject
    assert_equal [player.email], mail.to
    assert_equal ["noreply@picklepals.tools"], mail.from
    assert_match player.reset_token, mail.body.encoded
    assert_match CGI.escape(player.email), mail.body.encoded
  end

end
