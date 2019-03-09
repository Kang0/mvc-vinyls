require './app/uploader/images_uploader'

class UserImage < ActiveRecord::Base
  mount_uploader :image, ImagesUploader
  belongs_to :vinyl

end
