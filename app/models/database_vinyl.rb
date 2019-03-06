class DatabaseVinyl < ActiveRecord::Base
  belongs_to :users

  def slug_artist
    artist.downcase.gsub(" ","-")
  end

  def slug_album
    album_name.downcase.gsub(" ","-")
  end

  def self.find_by_artist_slug(slug)
    DatabaseVinyl.all.find{|vinyl| vinyl.slug_artist == slug}
  end

  def self.find_by_album_slug(slug)
    DatabaseVinyl.all.find{|vinyl| vinyl.slug_album == slug}
  end

end
