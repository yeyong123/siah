class UsersController < ApplicationController
  def new
		@user = User.new
  end

	def show
		@user = User.find(params[:id])
	end

	def create 
		@user = User.new(params[:user])
		if @user.save
			sign_in @user
			flash[:success] = "你已进入另一个世界"
			redirect_to @user
		else
			render 'new'
		end
	end
end
