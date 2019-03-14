class Vinyl < ActiveRecord::Base
  belongs_to :user
  has_one :user_image

  def slug_artist
    artist.downcase.gsub(" ","-")
  end

  def slug_album
    album_name.downcase.gsub(" ","-")
  end

  def self.find_by_artist_slug(slug)
    @artist = []
    Vinyl.find_each do |vinyl|
      #have to sandwich, its returning nil
      if vinyl.slug_artist == slug
        @artist << vinyl
      end
    end
    @artist
  end

  def self.find_by_album_slug(slug)
    Vinyl.all.find{|vinyl| vinyl.slug_album == slug}
  end

  def self.find_by_artist_and_user_id(artist:, user_id:)
    Vinyl.all.collect do |vinyl|
      if vinyl.slug_artist == artist && vinyl.user_id == user_id
        vinyl
      end
    end.compact
  end

  def self.find_by_album_and_user_id(album_name:, user_id:)
    Vinyl.all.collect do |vinyl|
      if vinyl.slug_album == album_name && vinyl.user_id == user_id
        vinyl
      end
    end.compact.first
  end
end
