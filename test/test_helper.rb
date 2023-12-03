ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Returns true if a test player is logged in.
  def is_logged_in?
    !session[:player_id].nil?
  end

  # Log in as a particular player.
  def log_in_as(player)
    session[:player_id] = player.id
  end
end

class ActionDispatch::IntegrationTest
  # Log in as a particular player.
  def log_in_as(player, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: player.email,
                               password: password,
                               remember_me: remember_me } }
  end
end
