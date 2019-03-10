require './app/uploader/user_images_uploader'

class UserImage < ActiveRecord::Base
  mount_uploader :image, UserImagesUploader
  belongs_to :vinyl

end
