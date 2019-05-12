require 'pry'
require 'rack-flash'


class SongsController < ApplicationController
  enable :sessions
  #configure do

    use Rack::Flash
  #end

  get '/songs' do
    @songs = Song.all.sort_by{|song| song.name}
    erb :'songs/index'
  end

  get '/songs/new' do
    @genres = Genre.all.sort_by{|song| song.name}
    @artists = Artist.all.sort_by{|song| song.name}
    erb :'songs/new'
  end

  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    erb :'songs/show'
  end

  get '/songs/:slug/edit' do
    @song = Song.find_by_slug(params[:slug])
    @genres = Genre.all.sort_by{|song| song.name}
    erb :'songs/edit'
  end

  post '/songs' do
    @song = Song.create(params[:song])
    if params[:artist][:name] == ""
      @song.artist = Artist.find(params[:artist_id])
    else
      @song.artist = Artist.find_or_create_by(name: params[:artist][:name])
    end
    @song.save
    flash[:message] = "Successfully created song."
    redirect "/songs/#{@song.slug}"
  end

  patch '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    if params[:artist][:name] != ""
      if Artist.find_by(name: params[:artist][:name])
        @song.artist = Artist.find_by(name: params[:artist][:name])
      else
        @song.artist = Artist.create(name: params[:artist][:name])
      end
    end

    @song.genres.clear
    params[:song][:genre_ids].each do |id|
      @song.genres << Genre.find(id)
    end

    @song.save
    flash[:message] = "Successfully updated song."
    redirect "/songs/#{@song.slug}"
  end

end
