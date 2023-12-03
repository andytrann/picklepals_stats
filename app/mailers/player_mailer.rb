class PlayerMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.player_mailer.password_reset.subject
  #
  def password_reset(player)
    @player = player
    mail to: player.email, subject: "Password reset"
  end
end
