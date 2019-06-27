require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest

  test "get signup user form and create user" do
    get signup_path
    assert_template 'users/new'
    assert_difference 'User.count', 1 do
      post users_path, params: {user: {username: "john", email: "john@doe.com", password: "password", admin: false}}
    end
    follow_redirect!
    assert_template 'users/show'
    assert_match "john", response.body
  end
end
