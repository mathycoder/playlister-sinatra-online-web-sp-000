class Artist < ActiveRecord::Base
  has_many :songs
  has_many :song_genres, through: :songs
  has_many :genres, through: :song_genres

  # if Artist.all.empty?
  #   LibraryParser.parse
  # end


  def slug
    self.name.downcase.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    self.all.find {|instance| instance.slug == slug}
  end



end


#The find_by_slug method should use the slug method to retrieve
#a song/artist/genre from the database and return that entry.
