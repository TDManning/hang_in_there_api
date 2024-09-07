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

    expect(response).to be_successful

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
    test_params = {
      name: "DEFEAT",
      description: "It's too late to start now.",
      price: 35.00,
      year: 2023,
      vintage: false,
      img_url:  "https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk"
    }
    post "/api/v1/posters", params: test_params.to_json, headers: { "Content-Type" => "application/json" }

    expect(response).to be_successful

    poster = JSON.parse(response.body, symbolize_names: true)
    created_poster = Poster.last
    expect(poster[:data][:attributes][:name]).to eq(created_poster[:name])
    expect(poster[:data][:attributes][:description]).to eq(created_poster[:description])
    expect(poster[:data][:attributes][:price]).to eq(created_poster[:price])
    expect(poster[:data][:attributes][:year]).to eq(created_poster[:year])
    expect(poster[:data][:attributes][:vintage]).to eq(created_poster[:vintage])
    expect(poster[:data][:attributes][:img_url]).to eq(created_poster[:img_url])
  end

  it "updates a poster" do
    poster = Poster.create(
      name: "REGRET",
      description: "Hard work rarely pays off.",
      price: 89.00,
      year: 2018,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )
    test_params = {name: "new_name"}
    original_name = poster.name
    new_name = test_params[:name]

    patch "/api/v1/posters/#{poster.id}", params: test_params.to_json, headers: { "Content-Type" => "application/json" }
    new_poster = JSON.parse(response.body, symbolize_names: true)
#require 'pry'; binding.pry
    expect(response).to be_successful
    expect(new_poster[:data][:attributes][:name]).to eq(new_name)
    expect(new_poster[:data][:attributes][:name]).not_to equal(original_name)
  end

  it "destroys a specifed poster" do
    poster = Poster.create(
      name: "REGRET",
      description: "Hard work rarely pays off.",
      price: 89.00,
      year: 2018,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )

    expect(poster).to be_a(Poster)
    expect(Poster.all).to include(poster)

    delete "/api/v1/posters/#{poster.id}"
    
    expect(Poster.all).not_to include(poster)
    expect(response).to be_successful
    expect(response).to have_http_status(:no_content)
  end

  it "produces a JSON response with a 'meta' for count" do
    poster_1 = Poster.create(
      name: "REGRET",
      description: "Hard work rarely pays off.",
      price: 89.00,
      year: 2018,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )
    poster_2 = Poster.create(
      name: "UNHAPPY",
      description: "Hard work rarely pays off.",
      price: 400.00,
      year: 1738,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )
    poster_3 = Poster.create(
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
    expect(posters[:meta][:count]).to eq(posters[:data].count)
  end

  it "sorts results ascending by query parameters" do
    poster_1 = Poster.create(
      name: "REGRET",
      description: "Hard work rarely pays off.",
      price: 89.00,
      year: 2018,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )
    poster_2 = Poster.create(
      name: "UNHAPPY",
      description: "Hard work rarely pays off.",
      price: 400.00,
      year: 1738,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )
    poster_3 = Poster.create(
      name: "BIG SAD",
      description: "Why smile when you can frown",
      price: 120.00,
      year: 2020,
      vintage: false,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )

    get "/api/v1/posters?sort=asc"

    expect(response).to be_successful
    posters = JSON.parse(response.body, symbolize_names: true)
    expect((posters[:data][0][:id]).to_s).to eq(poster_1[:id].to_s)
    expect((posters[:data][2][:id]).to_s).to eq(poster_3[:id].to_s)
  end

  it "sorts results descending by query parameters" do
    poster_1 = Poster.create(
      name: "REGRET",
      description: "Hard work rarely pays off.",
      price: 89.00,
      year: 2018,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )
    poster_2 = Poster.create(
      name: "UNHAPPY",
      description: "Hard work rarely pays off.",
      price: 400.00,
      year: 1738,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )
    poster_3 = Poster.create(
      name: "BIG SAD",
      description: "Why smile when you can frown",
      price: 120.00,
      year: 2020,
      vintage: false,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )

    get "/api/v1/posters?sort=desc"

    expect(response).to be_successful
    posters = JSON.parse(response.body, symbolize_names: true)
    expect((posters[:data][0][:id]).to_s).to eq(poster_3[:id].to_s)
    expect((posters[:data][2][:id]).to_s).to eq(poster_1[:id].to_s)
  end

  it "filters results based on name parameter" do
    poster_1 = Poster.create(
      name: "DISASTER",
      description: "como se dice 'epic fail'?",
      price: 28.00,
      year: 2018,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )
    poster_2 = Poster.create(
      name: "TERRIBLE",
      description: "Baka!",
      price: 15.00,
      year: 1738,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )
    poster_3 = Poster.create(
      name: "BIG SAD",
      description: "Why smile when you can frown",
      price: 120.00,
      year: 2020,
      vintage: false,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )

    get "/api/v1/posters?name=ter"

    expect(response).to be_successful
    posters = JSON.parse(response.body, symbolize_names: true)
    expect(posters[:data]).to be_an(Array)
    expect(posters[:data].length).to eq(2)
    expect((posters[:data][0][:attributes][:name])).to eq("DISASTER")
    expect((posters[:data][1][:attributes][:name])).to eq("TERRIBLE")

    get "/api/v1/posters?name=asdfghjkl"

    expect(response).to be_successful
    results = JSON.parse(response.body, symbolize_names: true)
    expect(results[:data]).to eq([])
  end

  it "filters results based on minimum price parameter" do
    poster_1 = Poster.create(
      name: "DISASTER",
      description: "como se dice 'epic fail'?",
      price: 28.00,
      year: 2018,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )
    poster_2 = Poster.create(
      name: "TERRIBLE",
      description: "Baka!",
      price: 15.00,
      year: 1738,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )
    poster_3 = Poster.create(
      name: "BIG SAD",
      description: "Why smile when you can frown",
      price: 120.00,
      year: 2020,
      vintage: false,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )

    get "/api/v1/posters?min_price=20"

    expect(response).to be_successful
    posters = JSON.parse(response.body, symbolize_names: true)
    expect(posters[:data]).to be_an(Array)
    expect(posters[:data].length).to eq(2)
    expect((posters[:data][0][:attributes][:name])).to eq(poster_1[:name])
    expect((posters[:data][1][:attributes][:name])).to eq(poster_3[:name])

    get "/api/v1/posters?min_price=2000"

    expect(response).to be_successful
    results = JSON.parse(response.body, symbolize_names: true)
    expect(results[:data]).to eq([])
  end

  it "filters results based on max price parameter" do
    poster_1 = Poster.create(
      name: "DISASTER",
      description: "como se dice 'epic fail'?",
      price: 28.00,
      year: 2018,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )
    poster_2 = Poster.create(
      name: "TERRIBLE",
      description: "Baka!",
      price: 15.00,
      year: 1738,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )
    poster_3 = Poster.create(
      name: "BIG SAD",
      description: "Why smile when you can frown",
      price: 120.00,
      year: 2020,
      vintage: false,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )

    get "/api/v1/posters?max_price=30"

    expect(response).to be_successful
    posters = JSON.parse(response.body, symbolize_names: true)
    expect(posters[:data]).to be_an(Array)
    expect(posters[:data].length).to eq(2)
    expect((posters[:data][0][:attributes][:name])).to eq(poster_1[:name])
    expect((posters[:data][1][:attributes][:name])).to eq(poster_2[:name])

    get "/api/v1/posters?min_price=2000"

    expect(response).to be_successful
    results = JSON.parse(response.body, symbolize_names: true)
    expect(results[:data]).to eq([])
  end
end

