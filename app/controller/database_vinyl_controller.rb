require 'pry'

class DatabaseVinylController < ApplicationController

  get '/database/new' do
    if logged_in?
      erb :'/DatabaseVinyl/new'
    else
      redirect '/login'
    end
  end

  get '/database/search' do
    erb :'/DatabaseVinyl/search'
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

  post '/database/new' do
    if params[:artist].empty? | params[:album_name].empty? | params[:year_released].empty?
      redirect '/database/new'
    else
      @dbvinyl = DatabaseVinyl.create(:artist => params[:artist], :album_name => params[:album_name], :record_label => params[:record_label], :year_released => params[:year_released], :genre => params[:genre], :user_id => session[:user_id])

      redirect "/database/vinyls"
    end
  end

  post '/save/:artist_slug/:album_slug' do
    @dbvinyl = DatabaseVinyl.find_by_album_slug(params[:album_slug])

    img = Image.new
    img.image = params[:file]
    img.database_vinyl = @dbvinyl
    img.save

    redirect to "/database/#{@dbvinyl.slug_artist}/#{@dbvinyl.slug_album}"
  end

  post '/database/search/result' do
    #couldn't figure out how to write a ternary operator to go to search or error
    #has to be a simplier way to write the below
    if params[:artist_name].empty? && params[:album_name].empty?
      redirect '/database/search'
    elsif params[:artist_name].empty?
      @dbvinyl = DatabaseVinyl.where(album_name: params[:album_name])

      if !@dbvinyl.empty?
        erb :'/DatabaseVinyl/results'
      else
        erb :'/DatabaseVinyl/error'
      end
    elsif params[:album_name].empty?
      @dbvinyl = DatabaseVinyl.where(artist: params[:artist_name])

      if !@dbvinyl.empty?
        erb :'/DatabaseVinyl/results'
      else
        erb :'/DatabaseVinyl/error'
      end
    else
      @dbvinyl = DatabaseVinyl.where(artist: params[:artist_name], album_name: params[:album_name])

      if !@dbvinyl.empty?
        erb :'/DatabaseVinyl/results'
      else
        erb :'/DatabaseVinyl/error'
      end
    end
  end

  patch '/database/:artist_slug/:album_slug/edit' do
    @dbvinyl = DatabaseVinyl.find_by_album_slug(params[:album_slug])
    @dbvinyl.update(artist: params[:artist], album_name: params[:album_name], record_label: params[:record_label], year_released: params[:year_released], genre: params[:genre])
    redirect "/database/#{@dbvinyl.slug_artist}/#{@dbvinyl.slug_album}"
  end

  delete '/database/:artist_slug/:album_slug/image/delete' do
    @dbvinyl = DatabaseVinyl.find_by_album_slug(params[:album_slug])
    @image = Image.find_by(database_vinyl_id: @dbvinyl.id)
    @image.remove_image!
    @image.delete

    redirect "/database/#{@dbvinyl.slug_artist}/#{@dbvinyl.slug_album}/edit"
  end

  delete '/database/:artist_slug/:album_slug/delete' do
    @dbvinyl = DatabaseVinyl.find_by_album_slug(params[:album_slug])
    @image = Image.find_by(database_vinyl_id: @dbvinyl.id)
    if @image == nil
      @dbvinyl.delete
    else
      @image.remove_image!
      @dbvinyl.delete
      @image.delete
    end
    redirect '/database/vinyls'
  end

end
