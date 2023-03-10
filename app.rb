require "sinatra"
require "sinatra/base"
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

  get "/albums/new" do
    return erb(:new_album)
  end

  post "/albums" do
    if invalid_request_parameters_albums?
      status 400
      return ""
    end
    albums = AlbumRepository.new
    album = Album.new
    album.title = params[:title]
    album.release_year = params[:release_year]
    album.artist_id = params[:artist_id]
    albums.create(album)
    return erb(:album_created)
  end

  def invalid_request_parameters_albums?
    params[:title] == nil || params[:release_year] == nil || params[:artist_id] == nil
  end

  get "/artists/new" do
    return erb(:new_artist)
  end

  post "/artists" do
    if invalid_request_parameters_artists?
      status 400
      return ""
    end
    artists = ArtistRepository.new
    artist = Artist.new
    artist.name = params[:name]
    artist.genre = params[:genre]
    artists.create(artist)
    return erb(:artist_created)
  end

  get "/albums/:id" do
    album_id = params[:id]
    albums = AlbumRepository.new
    @x = albums.find(album_id)
    artists = ArtistRepository.new
    @c = artists.find(@x.artist_id)
    return erb(:idalbum)
  end

  def invalid_request_parameters_artists?
    params[:name] == nil || params[:genre] == nil
  end

  get "/albums" do
    albums = AlbumRepository.new
    @album = albums.all

    return erb(:albums)
  end

  get "/artists" do
    artists = ArtistRepository.new
    @art = artists.all
    return erb(:artists)
  end

  get "/artists/:id" do
    artist_id = params[:id]
    artists = ArtistRepository.new
    @art1 = artists.find(artist_id)
    return erb(:idartists)
  end

  post "/artists" do
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
