class UsersController < ApplicationController
  before_action :set_collections, only: [:new]
  before_action :set_user, only: [:show, :edit, :destroy, :edit_skills]

  def index
  end

  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    binding.pry
    user.registration = current_registration
    if user.save
      user.add_tags(params[:tags])
      redirect_to edit_skills_user_path(user)
    else
      render plain: "hello guys, I didnt save"
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
    end
  end

  def destroy
    # waiting to add the status column on user.
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :location, :resume_file_path)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def edit_skills
    @skills_numeric_hash = @user.return_skills_hash
  end

  def edit_skills_return
    binding.pry

  end

  private

  def set_collections
    @skills = User::SKILLS
    @values = User::VALUES
    @salaries = User::SALARIES
  end

end
