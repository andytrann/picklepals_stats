module SessionsHelper
  # Logs in the given player.
  def log_in(player)
    session[:player_id] = player.id
  end

  # Remembers a player in a persistent session.
  def remember(player)
    player.remember
    cookies.permanent.encrypted[:player_id] = player.id
    cookies.permanent[:remember_token] = player.remember_token
  end

  # Returns the player corresponding to the remember token cookie.
  def current_player
    if (player_id = session[:player_id])
      @current_player ||= Player.find_by(id: player_id)
    elsif (player_id = cookies.encrypted[:player_id])
      player = Player.find_by(id: player_id)
      if player && player.authenticated?(:remember, cookies[:remember_token])
        log_in player
        @current_player = player
      end
    end
  end

  # Returns true if the given player is the current player.
  def current_player?(player)
    player && player == current_player
  end

  # Returns true if the player is logged in, false otherwise.
  def logged_in?
    !current_player.nil?
  end

  # Forgets a persistent session.
  def forget(player)
    player.forget
    cookies.delete(:player_id)
    cookies.delete(:remember_token)
  end

  #Logs out the current player.
  def log_out
    forget(current_player)
    session.delete(:player_id)
    @current_player = nil
  end

  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
