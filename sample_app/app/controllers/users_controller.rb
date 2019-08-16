class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :setting,
    :update_info, :following, :followers]
  # before_action :correct_user,   only: [:show]
  before_action :admin_user,     only: :destroy

  # Sign up user GET
  def new
    if current_user
      flash[:warning] = "Already logged"
      redirect_to '/setting'
    else
      @user = User.new
    end
  end

  # Sign up user POST
  def create
    @user = User.new(user_params)    # Not the final implementation!
    @user.password_digest = User.digest(user_params[:password])
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  # user profile infomation
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page], per_page: 7)
  end

  # user setting
  def setting
    @user = User.find(current_user.id)
    render 'setting'
  end

  # update user profile
  def update_info
    # upload avatar image to folder
    current_date = DateTime.now.strftime('%H_%M_%S_%L-%m_%d_%Y')
    user_avatar = params[:user][:avatar]
    file_extension = File.extname(user_avatar.original_filename)
    avatar = current_date + file_extension
    File.open(Rails.root.join("app", "assets/images", avatar ), "wb") do |file|
      file.write(user_avatar.read)
    end
    # upload data to database
    @user = User.find(current_user.id)
    update_options = user_params
    update_options[:avatar] = avatar
    if @user.update_attributes(update_options)
     flash[:success] = "Profile updated"
     redirect_to '/setting'
    else
     flash[:danger] = "Profile update failed"
     redirect_to '/setting'
    end
  end

  # delete user
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_path
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private
    # return hash from request body
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # correct user
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
