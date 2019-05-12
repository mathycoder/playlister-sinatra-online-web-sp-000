class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  enable :sessions
  set :session_secret, "my_application_secret"
  set :views, Proc.new { File.join(root, "../views/") }


  get '/' do
    erb :index
  end

  post '/search' do
    term = params[:query].downcase
    artist = Artist.all.find {|artist| artist.name.downcase.include?(term)}
    song = Song.all.find {|song| song.name.downcase.include?(term)}
    genre = Genre.all.find {|genre| genre.name.downcase.include?(term)}
    if artist
      redirect "/artists/#{artist.slug}"
    elsif song
      redirect "/songs/#{song.slug}"
    elsif genre
      redirect "/genres/#{genre.slug}"
    else
      erb :nothing
    end
  end
end
