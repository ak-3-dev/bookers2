class UsersController < ApplicationController
  allow_unauthenticated_access only: [ :new, :create ]
  before_action :is_maching_login_user, only: [ :edit, :update ]

  def new
    @user = User.new
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      start_new_session_for @user
      redirect_to user_path(@user), notice: "Welcome! You have signed up successfully."
    else
      flash.now[:alert] = "error: User could not be created."
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      flash.now[:alert] = "error: Book could not be updated."
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email_address, :password, :password_confirmation, :introduction, :profile_image)
  end

  def is_maching_login_user
    user = User.find(params[:id])
    unless user.id == Current.user.id
      redirect_to user_path(Current.user.id)
    end
  end
end
