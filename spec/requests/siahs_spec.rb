#encoding:utf-8
require 'spec_helper'

describe "Siahs" do
  describe "Home" do
    it "should have the h1 '主页'" do
      visit root_path
      page.should have_selector('h1', text: '主页')
    end

    it "should have the title '主页'" do
      visit root_path
      page.should have_selector('title', text: "siah | 主页")
    end
  end

  describe "Help" do
    it "should have the h1 '帮助'" do
      visit help_path
      page.should have_selector('h1',text: '帮助')
    end

    it "should have the title '帮助'" do
      visit help_path
      page.should have_selector('title', text: "siah | 帮助")
    end
  end

  describe "About" do
    it "should have the h1 '关于我'" do
      visit about_path
      page.should have_selector('h1', text: '关于我')
    end

    it "should have the title '关于我'" do
      visit about_path
      page.should have_selector('title', text: "siah | 关于我")
    end
  end

	describe "Contact" do
		it "should have the h1 '联系我'" do
			visit contact_path
			page.should have_selector('h1', text: '联系我')
		end


		it "should have the title '联系我'" do
			visit contact_path
			page.should have_selector('title', text: "siah | 联系我")
		end

		describe "for signed-in users" do
			let(:user){ FactoryGirl.create(:user)}
			before do
				FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
				FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
				sign_in user
				visit root_path
			end
			it "should render the user's feed" do
				user.feed.each do |item|
					page.should have_selector("li##{item.id}", text: item.content)
				end
			end
		end
	end
end
