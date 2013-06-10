require 'spec_helper'

describe "UserPages" do
	subject { page }
	
	describe "index" do
		let(:user) { FactoryGirl.create(:user)}
		before do
			sign_in user
			visit users_path
	end


		it { should have_selector('title', text: "用户")}
		it { should have_selector('h1', text: "用户")}

		describe "pagination" do
		#	it  { should have_selector('div.pagination')}
			it "should list each user" do
				User.paginate(page: 1).each do |user|
					page.should have_selector('li', text: user.name)
				end
			end
		end

		describe "delete link" do
			it { should_not have_link('delete')}
			
			describe "as an admin user" do
				let(:admin) { FactoryGirl.create(:admin)}
				before do
					sign_in admin
					visit users_path
				end

				it { should have_link('删除', href: user_path(User.first))}
				it "should be able to delete another user" do
					expect { click_link('删除')}.to change(User, :count).by(-1)
				end
				it { should_not have_link('删除', href: user_path(admin))}
			end
		end
	end
	describe "signup page" do
	
		before { visit signup_path }
		
		it { should have_selector('h1', text: '注册')}
		it { should have_selector('title', text: "siah | 注册")}
	end
	
	describe "profile page" do
		let(:user) { FactoryGirl.create(:user)}
		before { visit user_path(user)}
		
		it { should have_selector('h1', text: user.name)}
		it { should have_selector('title', text: user.name)}
	end

	describe "signup" do
		before { visit signup_path }
		let(:submit) { "创建我的帐户" }
		
		describe "with  invalid information" do
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end
		end

		describe "with valid information" do
			before do
				fill_in "用户名", 		with: "yeyong"
				fill_in "邮箱", 			with: "yeyong14@gmail.com"
				fill_in "密码", 			with: 123456
				fill_in "重复密码", 	with: 123456
			end
			
			describe "after saving the user" do
				before { click_button submit }
				let(:user) { User.find_by_email('user@example.com')}
				it { should have_link("退出")}
			end

			it "should create a user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end
		end
	end

	describe "edit" do
		let(:user){ FactoryGirl.create(:user)}
		before do
			sign_in user
			visit edit_user_path(user)
		end

		describe "page" do
			it { should have_selector('h1', text: "更新个人信息")}
			it { should have_selector('title', text: "编辑用户")}
			it { should have_link('更改头像', href: 'http://gravatar.com/emails')}
		end
		
		describe "with invalid inforamtion" do
			before { click_button "保存更改"}
			#it { should have_content('error') }
		end

		describe "with valid information" do
			let(:new_name)  { "New name" }
			let(:new_email) { "new@expamle.com" }
			before do
				fill_in "用户名", with: new_name
				fill_in "邮箱",   with: new_email
				fill_in "密码", 	with: user.password
				fill_in "重复密码", with: user.password
				click_button "保存更改"
			end

			it { should have_selector('title', text: new_name)}
			it { should have_selector('div.alert.alert-success')}
			it { should have_link("退出", href: signout_path)}
			specify { user.reload.name.should == new_name }
			specify { user.reload.email.should == new_email }
		end
	end
end
