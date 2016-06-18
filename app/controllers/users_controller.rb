class UsersController < ApplicationController
  def new
    @user = User.new # Used to create the user object required as an argument to form_for
  end

  def show
    @user = User.find(params[:id]) # retrieves user from the database using params method
    # debugger - byebug is a powerful method for tracking down applications errors and interactively debugging your app
  end

  def create
    @user = User.new(user_params) # this method creates a user with the required attributes
    if @user.save                 # and saves them
      flash[:success] = "Welcome to the Sample App!" # Once it saves, a flash message will appear
      redirect_to @user # and redirect you to the user profile page
    else
      render 'new' # if not, it will render the signup page again, usually because there was an error when signing up.
    end
  end

  private # we make it private so the method will be only used internally in users controller and not be externally exposed on the web

  def user_params # we want to require a strong params hash to have :user attribute, and to permit name, email, password, password_confirmation
    params.require(:user).permit(:name, :email, :password,
                                      :password_confirmation)
  end # if a user attribute is missing, it will raise an error.

end
