class VinylsController < ApplicationController

  post 'user/:username/add' do
    @user = User.find_by(username: params[:username])
    erb :'/vinyls/add'
  end

end
