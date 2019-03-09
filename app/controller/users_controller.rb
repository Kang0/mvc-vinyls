class UsersController < ApplicationController

  get '/signup' do
    if logged_in?
      redirect "/user/#{current_user.slug}"
    else
      erb :'/users/signup'
    end
  end

  post '/signup' do
    if params[:username].empty? | params[:password].empty?
      redirect '/signup'
    else
      @user = User.create(:username => params[:username], :password => params[:password])
      session[:user_id] = @user.id
      redirect "/user/#{@user.slug}"
    end
  end

  get '/login' do
    if logged_in?
      redirect "user/#{current_user.slug}"
    else
      erb :'/users/login'
    end
  end

  post '/login' do
    @user = User.find_by(username: params[:username])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/user/#{@user.slug}"
    else
      redirect '/login'
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      redirect '/login'
    else
      redirect '/login'
    end
  end

  get '/user/:user_slug' do
    @user = User.find_by_slug(params[:user_slug])

    if @user.id == session[:user_id]
      @vinyls = Vinyl.where(user_id: current_user.id)
      erb :'/users/homepage'
    else
      erb :'/users/error', locals: {message: "Please note that the user may only look at this specific homepage"}
    end
  end



end
