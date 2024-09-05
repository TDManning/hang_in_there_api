require "rails_helper"

describe "Posters API" do
  it "sends a list of posters" do
    Poster.create(
      name: "REGRET",
      description: "Hard work rarely pays off.",
      price: 89.00,
      year: 2018,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )

    Poster.create(
      name: "UNHAPPY",
      description: "Hard work rarely pays off.",
      price: 400.00,
      year: 1738,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )

    Poster.create(
      name: "BIG SAD",
      description: "Why smile when you can frown",
      price: 120.00,
      year: 2020,
      vintage: false,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )

    get "/api/v1/posters"

    expect(response).to be_successful

    posters = JSON.parse(response.body, symbolize_names: true)

    expect(posters[:data].count).to eq(3)

    posters[:data].each do |poster|
      expect(poster).to have_key(:id)
      expect(poster[:id]).to be_an(String)
      expect(poster[:type]).to be_a(String)
      expect(poster[:attributes]).to be_a(Hash)
      expect(poster[:attributes][:name]).to be_a(String)
      expect(poster[:attributes][:description]).to be_a(String)
      expect(poster[:attributes][:price]).to be_a(Float)
      expect(poster[:attributes][:year]).to be_a(Integer)
      expect(poster[:attributes][:vintage]).to be_a(TrueClass).or be_a(FalseClass)
      expect(poster[:attributes][:img_url]).to be_a(String)

    end
  end
  it "sends a specified instance of a poster based on id" do
    test_poster = Poster.create(
      name: "REGRET",
      description: "Hard work rarely pays off.",
      price: 89.00,
      year: 2018,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )

    Poster.create(
      name: "UNHAPPY",
      description: "Hard work rarely pays off.",
      price: 400.00,
      year: 1738,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )

    Poster.create(
      name: "BIG SAD",
      description: "Why smile when you can frown",
      price: 120.00,
      year: 2020,
      vintage: false,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )

    get "/api/v1/posters/#{test_poster.id}"

    posters = JSON.parse(response.body, symbolize_names: true)

    expect(posters[:data]).to be_a(Hash)
    expect(posters[:data][:type]).to be_a(String)
    expect(posters[:data][:attributes]).to be_a(Hash)
    expect(posters[:data][:attributes][:name]).to eq("REGRET")
    expect(posters[:data][:attributes][:description]).to eq("Hard work rarely pays off.")
    expect(posters[:data][:attributes][:price]).to eq(89.00)
    expect(posters[:data][:attributes][:year]).to eq(2018)
    expect(posters[:data][:attributes][:vintage]).to eq(true)
    expect(posters[:data][:attributes][:img_url]).to eq("https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")
  end

  it "generates a new poster" do
    post "/api/v1/posters"

    posters = JSON.parse(response.body, symbolize_names: true)
  end
end
