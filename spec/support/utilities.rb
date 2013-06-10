#encoding:utf-8
def sign_in(user)
	visit signin_path
	fill_in "邮箱", with: user.email
	fill_in "密码", with: user.password
	click_button "登录"
	cookies[:remember_token] = user.remember_token
end
