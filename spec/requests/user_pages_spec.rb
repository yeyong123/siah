require 'spec_helper'

describe "UserPages" do
	subject { page }
	
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
end
