require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
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
  end

  test 'valid signup information' do # the post_via_redirect method arranges to follow the redirect after submission
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name: "Ruben",
                                            email: "cruz14@gmail.com",
                                            password: "chavezcruz",
                                            password_confirmation: "chavezcruz" }
    end
    assert_template 'users/show' # this also tests if the page renders if the signup is successful
  end
end
