class VinylsController < ApplicationController

  get '/vinyls' do
    if logged_in?
      @user = User.find_by(id: session[:user_id])
      @vinyls = Vinyl.all
      erb :'/vinyls/vinyls'
    else
      redirect '/login'
    end
  end

  get '/vinyls/new' do
    if logged_in?
      erb :'/vinyls/new'
    else
      redirect '/login'
    end
  end

  post '/vinyls/new' do
    if params[:artist].empty? | params[:album_name].empty?
      redirect '/vinyls/new'
    else
      @vinyl = Vinyl.create(:artist => params[:artist], :album_name => params[:album_name], :record_label => params[:record_label], :year_released => params[:year_released], :genre => params[:genre])
      UsersVinyls.create(:user_id => session[:user_id], :vinyl_id => @vinyl.id)
      redirect "/vinyls/#{@vinyl.slug_artist}/#{@vinyl.slug_album}"
    end
  end

  get '/vinyls/:artist_slug' do
    @artist = Vinyl.find_by_artist_slug(params[:artist_slug])

    erb :'/vinyls/artist'
  end

  get '/vinyls/:artist_slug/:album_slug' do
    @album = Vinyl.find_by_album_slug(params[:album_slug])

    erb :'/vinyls/album'
  end



end
