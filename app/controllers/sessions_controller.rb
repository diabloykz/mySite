class SessionsController < ApplicationController

  def new

  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
      if user && user.authenticate(params[:session][:password])
        session[:user_id] = user.id
        flash[:success] = "Vous êtes bien connecté, #{user.username}."
        redirect_to user_path(user)
      else
        flash.now[:danger] = "Email et/ou mot de passe incorrects"
        render 'new'
      end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "Vous êtes bien déconnecté"
    redirect_to root_path
  end
end
