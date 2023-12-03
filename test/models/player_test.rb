require "test_helper"

class PlayerTest < ActiveSupport::TestCase
  def setup
    @player = Player.new(name: "Example Player", email: "player@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @player.valid?
  end

  test "name should be present" do
    @player.name = ""
    assert_not @player.valid?
  end

  test "email should be present" do
    @player.email = "     "
    assert_not @player.valid?
  end

  test "name should not be too long" do
    @player.name = "a" * 51
    assert_not @player.valid?
  end

  test "email should not be too long" do
    @player.email = "a" * 244 + "@example.com"
    assert_not @player.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[player@example.com PLAYER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @player.email = valid_address
      assert @player.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[player@example,com player_at_foo.org player.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @player.email = invalid_address
      assert_not @player.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_player = @player.dup
    @player.save
    assert_not duplicate_player.valid?
  end

  test "password should be present (nonblank)" do
    @player.password = @player.password_confirmation = " " * 6
    assert_not @player.valid?
  end

  test "password should have a minimum length" do
    @player.password = @player.password_confirmation = "a" * 5
    assert_not @player.valid?
  end

  test "authenticated? should return false for a player with nil digest" do
    assert_not @player.authenticated?(:remember, '')
  end
end
