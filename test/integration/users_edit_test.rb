require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:slothboy)
  end

  test "unsuccessful edits" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { name: "",
                                    email: "foo@invalid",
                                    password: "foo",
                                    password_confirmation: "bar" }
    assert_template 'users/edit'
  end

  test "successful edits" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = "Ruben"
    email = "ruben14@email.com"
    patch user_path(@user), user: { name: name,
                                    email: email,
                                    password: "",
                                    password_confirmation: "" }
    assert_not flash.empty? # makes sure there is a successful flash message
    assert_redirected_to @user
    @user.reload # .reload checks to see if the user attributes were updated.
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

end
