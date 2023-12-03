# Preview all emails at http://localhost:3000/rails/mailers/player_mailer
class PlayerMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/player_mailer/password_reset
  def password_reset
    player = Player.first
    player.reset_token = Player.new_token
    PlayerMailer.password_reset(player)
  end

end
