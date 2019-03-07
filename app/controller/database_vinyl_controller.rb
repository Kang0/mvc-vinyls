class DatabaseVinylController < ApplicationController

  get '/database/new' do
    if logged_in?
      erb :'/DatabaseVinyl/new'
    else
      redirect '/login'
    end
  end

  post '/save_image' do
    @filename = params[:file][:filename]
    file = params[:file][:tempfile]

    File.open("./public/images/#{@filename}", 'wb') do |f|
      f.write(file.read)
    end

    erb :show_image
  end

  post '/database/new' do
    if params[:artist].empty? | params[:album_name].empty? | params[:year_released].empty?
      redirect '/database/new'
    else
      @dbvinyl = DatabaseVinyl.create(:artist => params[:artist], :album_name => params[:album_name], :record_label => params[:record_label], :year_released => params[:year_released], :genre => params[:genre], :user_id => session[:user_id])

      redirect "/database/vinyls"

      # @user = User.find_by(id: session[:user_id])
      # binding.pry
      # @user_vinyls = UserVinyl.new
      # @vinyl.user_vinyls << @user_vinyls
      # @user.user_vinyls << @user_vinyls
      # redirect "/users/#{@user.slug}"
    end
  end

  get '/database/vinyls' do
    @dbvinyls = DatabaseVinyl.all
    erb :'/DatabaseVinyl/show_database'
  end

  get '/database/:artist_slug' do
    @dbvinyl = DatabaseVinyl.find_by_artist_slug(params[:artist_slug])
    erb :'/DatabaseVinyl/show_artist'
  end

  get '/database/:artist_slug/:album_slug' do
    @dbvinyl = DatabaseVinyl.find_by_album_slug(params[:album_slug])
    erb :'/DatabaseVinyl/show_album'
  end

  get '/database/:artist_slug/:album_slug/edit' do
    @dbvinyl = DatabaseVinyl.find_by_album_slug(params[:album_slug])

    if session[:user_id] == @dbvinyl.user_id
      erb :'/DatabaseVinyl/edit'
    else
      erb :'/users/error'
    end
  end

  patch '/database/:artist_slug/:album_slug/edit' do
    @dbvinyl = DatabaseVinyl.find_by_album_slug(params[:album_slug])
    @dbvinyl.update(artist: params[:artist], album_name: params[:album_name], record_label: params[:record_label], year_released: params[:year_released], genre: params[:genre])
    redirect "/database/#{@dbvinyl.slug_artist}/#{@dbvinyl.slug_album}"
  end

  delete '/database/:artist_slug/:album_slug/delete' do
    @dbvinyl = DatabaseVinyl.find_by_album_slug(params[:album_slug])
    @dbvinyl.delete
    redirect '/database/vinyls'
  end

end
