require "spec_helper"
require "rack/test"
require_relative "../../app"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context "GET /" do
    it "returns album based on id with 200 OK" do
      response = get("/albums/2")
      expect(response.status).to eq(200)
      expect(response.body).to eq "Surfer Rosa - 1988 - Pixies"
    end

    it "returns list of all artists with 200 OK" do
      response = get("/artists/")
      expect(response.status).to eq(200)
      expect(response.body).to eq "Pixies, ABBA, Taylor Swift, Nina Simone, Kiasmos"
    end
  end

  context "POST /" do
    it "creates album entry and returns 200 OK" do
      response = post("/albums/?title=Voyage&release_year=2022&artist_id=2")
      expect(response.status).to eq(200)
      expect(response.body).to eq ""
      response = get("/albums/13")
      expect(response.body).to eq "Voyage - 2022 - ABBA"
    end

    it "creates artist entry and returns 200 OK" do
      response = post("/artists/?name=Wild nothing&genre=Indie")
      expect(response.status).to eq(200)
      expect(response.body).to eq ""
      response = get("/artists/")
      expect(response.body).to eq "Pixies, ABBA, Taylor Swift, Nina Simone, Kiasmos, Wild nothing"
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
