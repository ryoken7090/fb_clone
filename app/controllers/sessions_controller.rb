class SessionsController < ApplicationController
  def new
  end
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
        session[:user_id] = user.id
        redirect_to stories_path
    else
        flash.now[:notice] = 'ログインに失敗しました'

        render :new
    end
  end
  def destroy
    session.delete(:user_id)
    # flash[:notice] = 'ログアウトしました'

    redirect_to new_session_path, notice: "ログアウトしました！"
  end
end
