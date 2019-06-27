class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show]
  before_action :require_same_user, only: [:edit, :update]
  before_action :require_admin , only: [:destroy]

  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success]= "Bienvenue sur Tahiti Web Services #{@user.username}"
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Votre compte a bien été modifié"
      redirect_to articles_path
    else
      render 'edit'
    end
  end

  def show
    @user_articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end

  def destroy
    @user = User.find(params[:id])
    if @user != current_user
      @user.destroy
      flash[:danger] = "L'utilisateur et tous les articles qui lui sont associés ont été supprimé"
      redirect_to users_path
    else
      flash[:danger] = "Désactiver le rôle administrateur avant de supprimer ce compte"
      redirect_to users_path
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username,:email,:password)
  end

  def require_same_user
    if current_user != @user && !current_user.admin?
      flash[:danger] = "Vous ne pouvez éditer uniquement votre propre compte"
      redirect_to root_path
    end
  end

  def require_admin
    if logged_in? and !current_user.admin?
      flash[:danger] = "Seul un administrateur peut performer cette action"
      redirect_to root_path
    end
  end
end
