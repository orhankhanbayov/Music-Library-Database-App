require "sinatra"
require "sinatra/reloader"
require_relative "lib/database_connection"
require_relative "lib/album_repository"
require_relative "lib/artist_repository"
require_relative "lib/album"
require_relative "lib/artist"

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload "lib/album_repository"
    also_reload "lib/artist_repository"
    also_reload "lib/album"
    also_reload "lib/artist"
  end

  get "/albums/:id" do
    album_id = params[:id]
    albums = AlbumRepository.new
    x = albums.find(album_id)
    artists = ArtistRepository.new
    c = artists.find(x.artist_id.to_i)
    return "#{x.title} - #{x.release_year} - #{c.name}"
  end

  get "/artists/" do
    artists = ArtistRepository.new
    arr = []
    artists.all.each { |artist| arr << artist.name }
    return arr.join(", ")
  end

  post "/albums/" do
    albums = AlbumRepository.new
    album = Album.new
    album.title = params[:title]
    album.release_year = params[:release_year]
    album.artist_id = params[:artist_id]
    albums.create(album)
    return nil
  end

  post "/artists/" do
    artists = ArtistRepository.new
    artist = Artist.new
    artist.name = params[:name]
    artist.genre = params[:genre]
    artists.create(artist)
    return nil
  end

  delete "/albums/:id" do
    album_id = params[:id]
    albums = AlbumRepository.new
    albums.delete(album_id)
    return nil
  end
end
