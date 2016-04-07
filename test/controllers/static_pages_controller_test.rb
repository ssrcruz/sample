require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  setup = "| Ruby on Rails Tutorial Sample App"
  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "Home #{setup}"
  end

  test "should get help" do
    get :help
    assert_response :success
    assert_select "title", "Help #{setup}"
  end

  test "should get about" do
    get :about
    assert_response :success
    assert_select "title", "About #{setup}"
  end

  test "should get contact" do
    get :contact
    assert_response :success
    assert_select "title", "Contact #{setup}"
  end
end
