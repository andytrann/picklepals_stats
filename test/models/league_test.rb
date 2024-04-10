require "test_helper"

class LeagueTest < ActiveSupport::TestCase
  def setup
    @league = leagues(:leaguetest)
  end

  test "should be valid" do
    assert @league.valid?
  end

  test "should require creator" do
    @league.creator_id = nil
    assert_not @league.valid?
  end

  test "should require name" do
    @league.name = nil
    assert_not @league.valid?
  end

  test "should require valid status" do
    @league.status = nil
    assert_not @league.valid?
    assert_raise Exception do
      @league.status = "invalid status"
    end
  end

  test "should require closed_at if status is closed" do
    assert_raise ActiveRecord::RecordInvalid do
      @league.status_closed!
    end
  end

  test "should require closed_at to be nil if status is pending or ongoing" do
    assert_raise ActiveRecord::RecordInvalid do
      @league.update_attribute(:closed_at, Time.now.utc)
      @league.status_pending!
    end

    assert_raise ActiveRecord::RecordInvalid do
      @league.update_attribute(:closed_at, Time.now.utc)
      @league.status_ongoing!
    end
  end
end
