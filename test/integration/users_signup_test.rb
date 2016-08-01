require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end
  # This assert_no_difference method test checks the user count before posting the data and then checks to see if the user count is the same.
  test 'invalid signup information' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name: "",
                               email: "user@invalid",
                               password: "foo",
                               password_confirmation: "bar" }

    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test 'valid signup information with account activation' do # the post_via_redirect method arranges to follow the redirect after submission
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, user: { name: "Ruben",
                               email: "cruz14@gmail.com",
                               password: "chavezcruz",
                               password_confirmation: "chavezcruz" }
    end
    # assert_template 'users/show' # this also tests if the page renders if the signup is successful
    # assert is_logged_in?
    assert_equal 1, ActionMailer::Base.deliveries.size # Checks that the message was only sent once to the user
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end

end
