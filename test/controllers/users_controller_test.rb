require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  test "should get new" do
    get :new
    assert_response :success
  end

  def setup
    @user = users(:slothboy)
    @other_user = users(:grizzlyman)
  end

  test 'should redirect edit if not logged in' do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect update if not logged in' do
    get :update, id: @user, user: { name: @user.name, email: @user.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect edit if logged in as a different user' do
    log_in_as(@other_user)
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect update if logged in as a different user' do
    log_in_as(@other_user)
    patch :edit, id: @user, user: { name: @user.name, email: @user.email }
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect to index if not logged in' do
    get :index
    assert_redirected_to login_url
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end

  test 'should redirect destroy when logged in as non-admin' do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do # makes sure the user.count doesn't change
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end

  test 'should redirect following when not logged in' do
    get :following, id: @user
    assert_redirected_to login_url
  end

  test 'should redirect followers when not logged in' do
    get :followers, id: @user
    assert_redirected_to login_url
  end
end
