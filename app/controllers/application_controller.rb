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
    @artists = []
    @songs = []
    @genres = []
    @artists << Artist.all.select {|artist| artist.name.downcase.include?(term)}
    @songs << Song.all.select {|song| song.name.downcase.include?(term)}
    @genres << Genre.all.select {|genre| genre.name.downcase.include?(term)}
    @artists = @artists.flatten
    @genres = @genres.flatten
    @songs = @songs.flatten
    erb :search
  end
end
