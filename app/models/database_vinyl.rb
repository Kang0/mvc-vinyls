class DatabaseVinyl < ActiveRecord::Base
  belongs_to :user
  has_one :image

  def slug_artist
    artist.downcase.gsub(" ","-")
  end

  def slug_album
    album_name.downcase.gsub(" ","-")
  end

  def self.find_by_artist_slug(slug)
    @artist = []
    DatabaseVinyl.find_each do |vinyl|
      #have to sandwich, its returning nil
      if vinyl.slug_artist == slug
        @artist << vinyl
      end
    end
    @artist
  end

  def self.find_by_album_slug(slug)
    DatabaseVinyl.all.find{|vinyl| vinyl.slug_album == slug}
  end

end
