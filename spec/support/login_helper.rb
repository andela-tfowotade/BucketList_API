module LoginHelper
  def login(user)
    post api_v1_login_url, email: user.email, password: "password"
    user.reload
  end
end
