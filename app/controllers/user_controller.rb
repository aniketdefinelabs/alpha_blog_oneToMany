class UserController < ApplicationController
  def register
  end

  def addUser
    @user =User.new(params.require(:user).permit(:name, :email, :password, :profile_picture))
    @user.save
    redirect_to "/login"
  end

  def login
  end

  def loginUser
    @user = User.find_by(email: params[:session][:email])
    if  @user && @user.authenticate(params[:session][:password])
      session[:user_id]=@user.id
      redirect_to "/home", notice: "Login Successfully"
    else
      redirect_to "/register", notice: "Wrong credentials"
    end
  end

  def edit
  end

  def UserProfile
    @user = User.find(params[:id])
    @articles=@user.articles.paginate(page: params[:page], per_page: 4)
  end

  def upload_picture
    @user = User.find(params[:id])
    if params[:profile_picture].present?
      @user.profile_picture.attach(params[:profile_picture])
      redirect_to "/UserProfile", notice: "Profile picture uploaded successfully!"
    else
      redirect_to user_profile_path(@user), alert: "Please select a file to upload."
    end
  end
end
