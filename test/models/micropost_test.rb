require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:joe)
    @micropost = @user.microposts.build(content: "Hello Joe, this is a test")
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do
    @micropost.content = ""
    assert_not @micropost.valid?
  end

  test "content should be 140 characters or less" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end

end
