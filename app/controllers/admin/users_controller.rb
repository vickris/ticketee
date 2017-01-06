class Admin::UsersController < Admin::ApplicationController
  def index
    @users = User.order(:email)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = "User has been created"
      redirect_to admin_users_path
    else
      flash.now[:danger] = "Error creating user"
      render :new
    end
  end



  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end