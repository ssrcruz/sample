require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase
  def setup
    @micropost = microposts(:orange)
  end

  test 'should redirect create when not logged in' do
    assert_no_difference 'Micropost.count' do
      post :create, micropost: {content: "Lorem ipsum"}
    end
    assert_redirected_to login_url
  end

  test 'should redirect destroy if not logged in' do
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: @micropost
    end
    assert_redirected_to login_url
  end

  test 'should redirect destroy to wrong post' do
    log_in_as(users(:slothboy))
    micropost = microposts(:ants)
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: micropost
    end
    assert_redirected_to root_url
  end
end
