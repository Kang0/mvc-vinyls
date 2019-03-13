require 'pry'

class DatabaseVinylController < ApplicationController

  get '/database/new' do
    if logged_in?
      erb :'/DatabaseVinyl/new', :layout => :"layout/internal"
    else
      redirect '/'
    end
  end

  get '/database/search' do
    erb :'/DatabaseVinyl/search', :layout => :"layout/internal"
  end

  get '/database/vinyls' do
    @dbvinyls = DatabaseVinyl.all
    erb :'/DatabaseVinyl/show_database', :layout => :"layout/internal"
  end

  get '/database/:artist_slug' do
    @dbvinyl = DatabaseVinyl.find_by_artist_slug(params[:artist_slug])
    erb :'/DatabaseVinyl/show_artist', :layout => :"layout/internal"
  end

  get '/database/:artist_slug/:album_slug' do
    @dbvinyl = DatabaseVinyl.find_by_album_slug(params[:album_slug])
    erb :'/DatabaseVinyl/show_album', :layout => :"layout/internal"
  end

  get '/database/:artist_slug/:album_slug/edit' do
    @dbvinyl = DatabaseVinyl.find_by_album_slug(params[:album_slug])

    if session[:user_id] == @dbvinyl.user_id
      erb :'/DatabaseVinyl/edit', :layout => :"layout/internal"
    else
      erb :'/users/error'
    end
  end

  post '/database/new' do
    if params[:artist].empty? | params[:album_name].empty? | params[:year_released].empty?
      redirect '/database/new'
    else
      @dbvinyl = DatabaseVinyl.create(:artist => params[:artist], :album_name => params[:album_name], :record_label => params[:record_label], :year_released => params[:year_released], :genre => params[:genre], :user_id => session[:user_id])

      img = Image.new
      img.image = params[:file]
      img.save
      @dbvinyl.image = img

      redirect "/database/vinyls"
    end
  end

  post '/database/search/result' do
    #couldn't figure out how to write a ternary operator to go to search or error
    #has to be a simplier way to write the below
    if params[:artist_name].empty? && params[:album_name].empty?
      redirect '/database/search'
    elsif params[:artist_name].empty?
      @dbvinyl = DatabaseVinyl.where(album_name: params[:album_name])

      if !@dbvinyl.empty?
        erb :'/DatabaseVinyl/results', :layout => :"layout/internal"
      else
        erb :'/DatabaseVinyl/error', :layout => :"layout/internal"
      end
    elsif params[:album_name].empty?
      @dbvinyl = DatabaseVinyl.where(artist: params[:artist_name])

      if !@dbvinyl.empty?
        erb :'/DatabaseVinyl/results', :layout => :"layout/internal"
      else
        erb :'/DatabaseVinyl/error', :layout => :"layout/internal"
      end
    else
      @dbvinyl = DatabaseVinyl.where(artist: params[:artist_name], album_name: params[:album_name])

      if !@dbvinyl.empty?
        erb :'/DatabaseVinyl/results', :layout => :"layout/internal"
      else
        erb :'/DatabaseVinyl/error', :layout => :"layout/internal"
      end
    end
  end

  patch '/database/:artist_slug/:album_slug/edit' do
    @dbvinyl = DatabaseVinyl.find_by_album_slug(params[:album_slug])
    @dbvinyl.update(artist: params[:artist], album_name: params[:album_name], record_label: params[:record_label], year_released: params[:year_released], genre: params[:genre])

    if params[:file] == nil
      redirect "/database/#{@dbvinyl.slug_artist}/#{@dbvinyl.slug_album}"
    else
      img = Image.find_by(database_vinyl_id: @dbvinyl.id)
      img.delete
      new_img = Image.new
      new_img.image = params[:file]
      new_img.save
      @dbvinyl.image = new_img
      redirect "/database/#{@dbvinyl.slug_artist}/#{@dbvinyl.slug_album}"
    end
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
