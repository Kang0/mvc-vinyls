class UserImagesUploader < CarrierWave::Uploader::Base
  def store_dir
    'uploads/user'
  end
end
