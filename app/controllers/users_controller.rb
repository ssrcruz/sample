class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def new
    @user = User.new # Used to create the user object required as an argument to form_for
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id]) # retrieves user from the database using params method
    # debugger - byebug is a powerful method for tracking down applications errors and interactively debugging your app
  end

  def create
    @user = User.new(user_params) # this method creates a user with the required attributes
    if @user.save # and saves them
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
      # log_in @user
      # flash[:success] = "Welcome to the Sample App!" # Once it saves, a flash message will appear
      # redirect_to @user # and redirect you to the user profile page
    else
      render 'new' # if not, it will render the signup page again, usually because there was an error when signing up.
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id]) # retrieves user from the database using user_params
    if @user.update_attributes(user_params) # if any attributes have been changed save them
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:danger] = "Deleted user."
    redirect_to users_url
  end

  # confirms a logged-in user
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  # confirms the correct user
  def correct_user
    @user = User.find(params[:id])
    unless current_user?(@user)
      flash[:danger] = "Please login as the correct user."
      redirect_to root_url
    end
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
  private # we make it private so the method will be only used internally in users controller and not be externally exposed on the web

  def user_params # we want to require a strong params hash to have :user attribute, and to permit name, email, password, password_confirmation
    params.require(:user).permit(:name, :email, :password,
                                      :password_confirmation)
  end # if a user attribute is missing, it will raise an error.

end
