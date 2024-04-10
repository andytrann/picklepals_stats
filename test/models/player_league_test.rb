require "test_helper"

class PlayerLeagueTest < ActiveSupport::TestCase
  def setup
    @playerleague = player_leagues(:playerleaguetest)
    @crystal = players(:crystaltest)
  end

  test "should be valid" do
    assert @playerleague.valid?
  end

  test "should require player" do
    @playerleague.player = nil
    assert_not @playerleague.valid?
  end

  test "should require league" do
    @playerleague.league = nil
    assert_not @playerleague.valid?
  end

  test "should require valid role" do
    @playerleague.role = nil
    assert_not @playerleague.valid?
    assert_raise Exception do
      @playerleague.role = "invalid role"
    end
  end

  test "should require valid status" do
    @playerleague.status = nil
    assert_not @playerleague.valid?
    assert_raise Exception do
      @playerleague.status = "invalid status"
    end
  end

  test "should require invited_at timestamp" do
    @playerleague.invited_at = nil
    assert_not @playerleague.valid?
  end

  test "should check creator role in league data entry" do
    @playerleague.player = @crytal
    assert_not @playerleague.valid?
  end

  test "should ensure that proctor or participant isn't also creator in league data entry" do
    assert_raise ActiveRecord::RecordInvalid do
      @playerleague.role_proctor!
    end

    assert_raise ActiveRecord::RecordInvalid do
      @playerleague.role_participant!
    end
  end
end
