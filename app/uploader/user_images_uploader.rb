class UserImagesUploader < CarrierWave::Uploader::Base
  def store_dir
    'uploads/user'
  end

  def default_url
    "/images/fallback/" + [version_name, "default.jpg"].compact.join('_')
  end

end
