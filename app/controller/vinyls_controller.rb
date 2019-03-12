class VinylsController < ApplicationController

  post '/user/add' do
    @dbvinyl = DatabaseVinyl.find_by(album_name: params[:album])
    @vinyl = Vinyl.create(artist: @dbvinyl.artist, album_name: @dbvinyl.album_name, record_label: @dbvinyl.record_label, year_released: @dbvinyl.year_released, genre: @dbvinyl.genre, user_id: current_user.id)
    if @dbvinyl.image == nil
      @user_image = UserImage.create(vinyl_id: @vinyl.id)
      @vinyl.user_image = @user_image
    else
      @user_image = UserImage.new
      @user_image.image = File.open(@dbvinyl.image.image.file.file)
      @user_image.save
      @vinyl.user_image = @user_image
    end
    erb :'/vinyls/add', :layout => :"layout/internal"
  end

  get '/user/:username/search' do
    erb :'/vinyls/search', :layout => :"layout/internal"
  end

  get '/user/:username/:artist_slug' do
    @vinyl = Vinyl.find_by_artist_and_user_id(artist: params[:artist_slug], user_id: session[:user_id])

    erb :'/vinyls/artist', :layout => :"layout/internal"
  end

  get '/user/:username/:artist_slug/:album_slug' do
    @vinyl = Vinyl.find_by_album_and_user_id(album_name: params[:album_slug], user_id: session[:user_id])

    erb :'/vinyls/album', :layout => :"layout/internal"
  end

  get '/user/:username/:artist_slug/:album_slug/edit' do
    @vinyl = Vinyl.find_by_album_and_user_id(album_name: params[:album_slug], user_id: session[:user_id])

    if session[:user_id] == @vinyl.user_id
      erb :'/vinyls/edit', :layout => :"layout/internal"
    else
      erb :'/vinyls/error', :layout => :"layout/internal"
    end
  end

  post '/user/:username/search/result' do
    #couldn't figure out how to write a ternary operator to go to search or error
    #has to be a simplier way to write the below
    if params[:artist_name].empty? && params[:album_name].empty?
      redirect "/user/#{current_user.slug}/search"
    elsif params[:artist_name].empty?
      @vinyl = Vinyl.where(album_name: params[:album_name])

      if !@vinyl.empty?
        erb :'/vinyls/result', :layout => :"layout/internal"
      else
        erb :'/vinyls/no_result', :layout => :"layout/internal"
      end
    elsif params[:album_name].empty?
      @vinyl = Vinyl.where(artist: params[:artist_name])

      if !@vinyl.empty?
        erb :'/vinyls/result', :layout => :"layout/internal"
      else
        erb :'/vinyls/no_result', :layout => :"layout/internal"
      end
    else
      @vinyl = Vinyl.where(artist: params[:artist_name], album_name: params[:album_name])

      if !@vinyl.empty?
        erb :'/vinyls/result', :layout => :"layout/internal"
      else
        erb :'/vinyls/no_result', :layout => :"layout/internal"
      end
    end
  end

  post '/user/:username/:artist_slug/:album_slug/image' do
    @vinyl = Vinyl.find_by_album_and_user_id(album_name: params[:album_slug], user_id: session[:user_id])

    img = UserImage.new
    img.image = params[:file]
    img.save
    @vinyl.user_image = img

    redirect to "/user/#{current_user.slug}/#{@vinyl.slug_artist}/#{@vinyl.slug_album}/edit"
  end

  patch '/database/:artist_slug/:album_slug/edit' do
    @vinyl = Vinyl.find_by_album_and_user_id(album_name: params[:album_slug], user_id: session[:user_id])
    @vinyl.update(artist: params[:artist], album_name: params[:album_name], record_label: params[:record_label], year_released: params[:year_released], genre: params[:genre])
    redirect "/user/#{current_user.slug}/#{@vinyl.slug_artist}/#{@vinyl.slug_album}"
  end

  delete '/user/:username/:artist_slug/:album_slug/image/delete' do
    @vinyl = Vinyl.find_by_album_and_user_id(album_name: params[:album_slug], user_id: session[:user_id])
    @image = UserImage.find_by(vinyl_id: @vinyl.id)
    @image.remove_image!
    @image.delete

    redirect "/user/#{current_user.slug}/#{@vinyl.slug_artist}/#{@vinyl.slug_album}/edit"
  end

  delete '/user/:username/:artist_slug/:album_slug/delete' do
    @vinyl = Vinyl.find_by_album_and_user_id(album_name: params[:album_slug], user_id: session[:user_id])
    @image = UserImage.find_by(vinyl_id: @vinyl.id)
    if @image == nil
      @vinyl.delete
    else
      @image.remove_image!
      @vinyl.delete
      @image.delete
    end
    redirect "/user/#{current_user.slug}"
  end

end
