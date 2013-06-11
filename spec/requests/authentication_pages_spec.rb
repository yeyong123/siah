require 'spec_helper'

describe "AuthenticationPages" do
	subject { page }

	describe "signin page" do
		before { visit signin_path }

		it { should have_selector('h1', text: "登录")}
		it { should have_selector('title', text: "siah | 登录")}
	end

	describe "signin" do
		before { visit signin_path }

		describe "with invalid information" do
			before { click_button "登录" }
			it { should have_selector('h1', text: "登录")}
			it { should have_selector('div.alert.alert-error', text: "无效")}
		end

		describe "with valid information" do
			let(:user) { FactoryGirl.create(:user)}
			before do
				fill_in "邮箱", with: user.email
				fill_in "密码", with: user.password
				click_button "登录"
			end
			it { should have_link('用户', href: users_path)}
			it { should have_selector('title', text: user.name)}
			it { should have_link('个人信息', href: user_path(user))}
			it { should have_link('设置', href: edit_user_path(user))}
			it { should have_link('退出', href: signout_path)}
			it { should_not have_link('登录', href: signin_path)}
			
			describe "followed by signout" do
				before { click_link "退出" }
				it { should have_link("登录")}
			end
		end
	end
#直接访问的控制器的编辑行为，这样是无效的行为，要先登录
	describe "authorizetion" do
		describe "for non-signed-in users" do
			let(:user) { FactoryGirl.create(:user) }
		
			#限制访问微博的资源	
			describe "in the Microposts controller" do
				
				describe "submiting to the create action" do
				#	before { post micropost_path }
				#	specify { response.should redirect_to(signin_path)}
				end
				
				describe "submiting to the destroy action" do
					before { delete micropost_path(FactoryGirl.create(:micropost))}
					specify { response.should redirect_to(signin_path)}
				end
			end

			describe "when attempting to visit a protected page" do
				before do
					visit edit_user_path(user)
					fill_in "邮箱", with: user.email
					fill_in "密码", with: user.password
					click_button "登录"
				end

				describe "after signing in" do
					it "should render the desired protected page" do
						page.should have_selector('title', text: "编辑用户")
					end
				end
			end
			describe "in the users controller" do
				
				describe "visiting the user index" do
					before { visit users_path }
					it { should have_selector('title', text: "登录")}
				end
				describe "visiting the edit page" do
					before { visit edit_user_path(user)}

					it { should have_selector('title', text: "登录")}
				end
		#如果直接从浏览器发送PUT请求，直接转到登录界面
				describe "submiting to the update action" do
					before { put user_path(user)}
					specify { response.should redirect_to(signin_path)}
				end
			end
		end
#用户只能编辑更新自己的信息
		describe "as wrong user" do
			let(:user) { FactoryGirl.create(:user)}
			let(:wrong_user) {FactoryGirl.create(:user, email: "wrong@example.com")}
			before { sign_in user }

			describe "visiting Users the edit page" do
				before { visit edit_user_path(wrong_user)}
				it { should_not have_selector('title', text: "siah | 编辑用户")}
			end
			#要是直接从浏览器发送PUT请求编辑行为
			describe "submiting a PUT request to the User the update action" do
				before { put user_path(wrong_user)}
				specify { response.should redirect_to(root_path)}
			end
		end

		describe "as non-admin user" do
			let(:user) { FactoryGirl.create(:user)}
			let(:non_admin) { FactoryGirl.create(:user)}

			before { sign_in non_admin }

			describe "submiting a DELETE request to the users the  destroy action" do
				before { delete user_path(user)}
				specify { response.should redirect_to(root_path)}
			end
		end
	end
end
