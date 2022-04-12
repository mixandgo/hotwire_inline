class UsersController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :set_user, only: %i[ show edit update destroy ]

  def index
    @users = User.all
  end

  def show; end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)

    if @user.save
      flash.now[:notice] = "User was successfully created."
      render turbo_stream: [
        turbo_stream.prepend("users", @user),
        turbo_stream.replace(
          "form_user",
          partial: "form",
          locals: { user: User.new }
        ),
        turbo_stream.replace("notice", partial: "layouts/flash")
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      flash.now[:notice] = "User was successfully updated."
      render turbo_stream: [
        turbo_stream.replace(@user, @user),
        turbo_stream.replace("notice", partial: "layouts/flash")
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    flash.now[:notice] = "User was successfully destroyed."
    render turbo_stream: [
      turbo_stream.remove(@user),
      turbo_stream.replace("notice", partial: "layouts/flash")
    ]
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :age, :dob, :phone)
    end
end
