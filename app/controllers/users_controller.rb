#encoding:utf-8
class UsersController < ApplicationController
	before_filter :signed_in_user, only: [:index,:edit, :update]
	before_filter :correct_user, only: [:edit, :update]
	before_filter :admin_user, only: :destroy

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

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user])
			flash[:success] = "个人资料已更新"
			sign_in @user
			redirect_to @user
		else
			render 'edit'
		end
	end

	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "用户删除"
		redirect_to users_path
	end

	def index
		@users = User.paginate(page: params[:page])
	end

	private

	def signed_in_user
		unless signed_in?
			store_location
			redirect_to signin_path, notice: "请登录" unless signed_in?
		end
	end

	def correct_user
		@user = User.find(params[:id])
		redirect_to root_path, notice: "做好你自己！不要试着改变别人" unless current_user?(@user)
	end

	def admin_user
		redirect_to root_path, notice: "你没有权限删除" unless current_user.admin?
	end
end
