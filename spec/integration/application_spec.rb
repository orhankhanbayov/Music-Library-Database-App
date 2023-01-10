require "spec_helper"
require "rack/test"
require_relative "../../app"

def reset_music_library_table
  seed_sql = File.read("spec/seeds/seeds_music_library.sql")
  connection = PG.connect({ host: "127.0.0.1", dbname: "music_library_test" })
  connection.exec(seed_sql)
end

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }
  before(:each) do
    reset_music_library_table
  end

  after(:each) do
    reset_music_library_table
  end

  context "GET /" do
    it "returns album based on id with 200 OK" do
      response = get("/albums/1")
      expect(response.status).to eq(200)
      expect(response.body).to include("<h1> Doolittle</h1>")
      expect(response.body).to include("Release year: 1989")
      expect(response.body).to include("Artist: Pixies")
    end

    it "returns list of all albums with 200 OK" do
      response = get("/albums")
      expect(response.status).to eq(200)
      expect(response.body).to include("<h1>Albums</h1>")
      expect(response.body).to include("Title: Doolittle")
      expect(response.body).to include("Released: 1989")
      expect(response.body).to include('<a href="/albums/1">Go to album page</a>')
    end

    it "returns album based on id with 200 OK" do
      response = get("/artists/1")
      expect(response.status).to eq(200)
      expect(response.body).to include("<h1> Pixies</h1>")
      expect(response.body).to include("Genre: Rock")
    end

    it "returns list of all artists with 200 OK" do
      response = get("/artists")
      expect(response.status).to eq(200)
      expect(response.body).to include("<h1>Artists</h1>")
      expect(response.body).to include("Name: Pixies")
      expect(response.body).to include('<a href="/artists/1">Go to artist page</a>')
    end
  end

  context "GET artists/new" do
    it "returns form and status 200" do
      response = get("artists/new")
      expect(response.body).to include('<input type="text" name="name">')
    end

    it "returns a sucess page and 200 OK" do
      response = post("artists?name=Wild nothing&genre=Indie")

      expect(response.status).to eq(200)
      expect(response.body).to include("<h1> Your artist was created! </h1>")
    end
  end

  context "GET /albums/new" do
    it "returns form and status 200" do
      response = get("/albums/new")
      expect(response.body).to include('<input type="text" name="title">')
    end

    it "returns a sucess page and 200" do
      response = post("albums?title=best of 20&release_year=2020&artist_id=3")
      expect(response.body).to include("<h1> Your album was created! </h1>")
    end
  end

  context "DELETE /" do
    it "deletes album based on id and returns 200" do
      response = delete("/albums/2")
      expect(response.status).to eq(200)
      expect(response.body).to eq ""
    end
  end
end
