require './app/uploader/images_uploader'

class Image < ActiveRecord::Base
  mount_uploader :image, ImagesUploader
  belongs_to :database_vinyl

end
