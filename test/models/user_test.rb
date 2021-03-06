require 'test_helper'
# assert ensures that the test is true
# assert_not ensures that the test is false

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Ruben", email: "ssrcruz@gmail.com", password: "venusflytrap", password_confirmation: "venusflytrap")
  end

  test "should be vaild" do
    @user.valid?
  end

  test "name should be present" do
    @user.name = "    "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "    "
    assert_not @user.valid?
  end

  test "name length" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email length" do
    @user.email = "a" * 256 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    # %w[] makes arrays of strings
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]

    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]

    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should not be blank" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
        @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    slothboy = users(:slothboy)
    grizzlyman = users(:grizzlyman)
    assert_not slothboy.following?(grizzlyman)
    slothboy.follow(grizzlyman)
    assert slothboy.following?(grizzlyman)
    assert grizzlyman.followers.include?(slothboy)
    slothboy.unfollow(grizzlyman)
    assert_not slothboy.following?(grizzlyman)
  end

  test 'should have the right posts' do
    michael = users(:michael)
    archer = users(:archer)
    lana = users(:lana)
    # Posts from followed user
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    # Post from self
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    # Posts from unfollowed user
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end

end
