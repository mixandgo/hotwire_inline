class UsersController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :set_user, only: %i[ show edit update destroy ]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render turbo_stream: [
        turbo_stream.prepend("users", @user),
        turbo_stream.replace("form_user", partial: "form", locals: { user: User.new })
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy

    render turbo_stream: [
      turbo_stream.remove(@user)
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
