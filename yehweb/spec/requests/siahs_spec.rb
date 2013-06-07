#encoding:utf-8
require 'spec_helper'

describe "Siahs" do
  describe "Home" do
    it "should have the h1 '主页'" do
      visit '/siah/home'
      page.should have_selector('h1', text: '主页')
    end

    it "should have the title '主页'" do
      visit '/siah/home'
      page.should have_selector('title', text: "siah | 主页")
    end
  end

  describe "Help" do
    it "should have the h1 '帮助'" do
      visit '/siah/help'
      page.should have_selector('h1',text: '帮助')
    end

    it "should have the title '帮助'" do
      visit '/siah/help'
      page.should have_selector('title', text: "siah | 帮助")
    end
  end

  describe "About" do
    it "should have the h1 '关于我'" do
      visit '/siah/about'
      page.should have_selector('h1', text: '关于我')
    end

    it "should have the title '关于我'" do
      visit '/siah/about'
      page.should have_selector('title', text: "siah | 关于我")
    end
  end
end
