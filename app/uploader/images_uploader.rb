class ImagesUploader < CarrierWave::Uploader::Base
  def store_dir
    'uploads/database'
  end
end
