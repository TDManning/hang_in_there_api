require "rails_helper"

describe "Posters API" do
  before(:each) do
    @poster_1 = Poster.create(
      name: "DISASTER",
      description: "como se dice 'epic fail'?",
      price: 28.00,
      year: 2018,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )
    @poster_2 = Poster.create(
      name: "TERRIBLE",
      description: "Baka!",
      price: 15.00,
      year: 1738,
      vintage: true,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )
    @poster_3 = Poster.create(
      name: "BIG SAD",
      description: "Why smile when you can frown",
      price: 120.00,
      year: 2020,
      vintage: false,
      img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
    )
  end

  it "sends a list of posters" do
    get "/api/v1/posters"

    expect(response).to be_successful

    result = JSON.parse(response.body, symbolize_names: true)

    expect(result[:data].count).to eq(3)

    result[:data].each do |poster|
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

    get "/api/v1/posters/#{@poster_1[:id]}"

    expect(response).to be_successful

    result = JSON.parse(response.body, symbolize_names: true)

    expect(result[:data]).to be_a(Hash)
    expect(result[:data][:type]).to be_a(String)
    expect(result[:data][:attributes]).to be_a(Hash)
    expect(result[:data][:attributes][:name]).to eq("DISASTER")
    expect(result[:data][:attributes][:description]).to eq("como se dice 'epic fail'?")
    expect(result[:data][:attributes][:price]).to eq(28.00)
    expect(result[:data][:attributes][:year]).to eq(2018)
    expect(result[:data][:attributes][:vintage]).to eq(true)
    expect(result[:data][:attributes][:img_url]).to eq("https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")
  end

  it "generates a new poster" do

    post "/api/v1/posters", params: @poster_1.to_json, headers: { "Content-Type" => "application/json" }

    expect(response).to be_successful

    result = JSON.parse(response.body, symbolize_names: true)

    expect(result[:data][:attributes][:name]).to eq(@poster_1[:name])
    expect(result[:data][:attributes][:description]).to eq(@poster_1[:description])
    expect(result[:data][:attributes][:price]).to eq(@poster_1[:price])
    expect(result[:data][:attributes][:year]).to eq(@poster_1[:year])
    expect(result[:data][:attributes][:vintage]).to eq(@poster_1[:vintage])
    expect(result[:data][:attributes][:img_url]).to eq(@poster_1[:img_url])
  end

  it "updates a poster" do

    test_params = {name: "new_name"}
    new_name = test_params[:name]

    patch "/api/v1/posters/#{@poster_1.id}", params: test_params.to_json, headers: { "Content-Type" => "application/json" }

    result = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful
    expect(result[:data][:attributes][:name]).to eq(new_name)
    expect(result[:data][:attributes][:name]).not_to equal("DISASTER")
  end

  it "destroys a specifed poster" do

    expect(@poster_1).to be_a(Poster)
    expect(Poster.all).to include(@poster_1)

    delete "/api/v1/posters/#{@poster_1.id}"
    
    expect(response).to be_successful
    expect(Poster.all).not_to include(@poster_1)
    expect(response).to have_http_status(:no_content)
  end

  it "produces a JSON response with a 'meta' for count" do

    #INDEX
    get "/api/v1/posters"

    expect(response).to be_successful
    result = JSON.parse(response.body, symbolize_names: true)
    expect(result[:meta][:count]).to eq(result[:data].count)

    #SHOW
    get "/api/v1/posters/#{@poster_1[:id]}"

    expect(response).to be_successful
    result = JSON.parse(response.body, symbolize_names: true)
    expect(result[:meta][:count]).to eq(1)

    #CREATE

    test_params = {name: "new_name"}
    new_name = test_params[:name]

    post "/api/v1/posters", params: @poster_1.to_json, headers: { "Content-Type" => "application/json" }

    expect(response).to be_successful
    result = JSON.parse(response.body, symbolize_names: true)
    expect(result[:meta][:count]).to eq(1)
  end

  it "sorts results ascending by query parameters" do

    get "/api/v1/posters?sort=asc"

    expect(response).to be_successful
    result = JSON.parse(response.body, symbolize_names: true)
    expect((result[:data][0][:id]).to_s).to eq(@poster_1[:id].to_s)
    expect((result[:data][2][:id]).to_s).to eq(@poster_3[:id].to_s)
  end

  it "sorts results descending by query parameters" do

    get "/api/v1/posters?sort=desc"

    expect(response).to be_successful
    result = JSON.parse(response.body, symbolize_names: true)
    expect((result[:data][0][:id]).to_s).to eq(@poster_3[:id].to_s)
    expect((result[:data][2][:id]).to_s).to eq(@poster_1[:id].to_s)
  end

  it "filters results based on name parameter" do

    get "/api/v1/posters?name=ter"

    expect(response).to be_successful
    result = JSON.parse(response.body, symbolize_names: true)
    expect(result[:data]).to be_an(Array)
    expect(result[:data].length).to eq(2)
    expect(result[:data][0][:attributes][:name]).to eq("DISASTER")
    expect(result[:data][1][:attributes][:name]).to eq("TERRIBLE")
  end

  it "filters results based on minimum price parameter" do

    get "/api/v1/posters?min_price=20"

    expect(response).to be_successful
    result = JSON.parse(response.body, symbolize_names: true)
    expect(result[:data]).to be_an(Array)
    expect(result[:data].length).to eq(2)
    expect(result[:data][0][:attributes][:name]).to eq(@poster_1[:name])
    expect(result[:data][1][:attributes][:name]).to eq(@poster_3[:name])
  end

  it "filters results based on max price parameter" do

    get "/api/v1/posters?max_price=30"

    expect(response).to be_successful
    result = JSON.parse(response.body, symbolize_names: true)
    expect(result[:data]).to be_an(Array)
    expect(result[:data].length).to eq(2)
    expect(result[:data][0][:attributes][:name]).to eq(@poster_1[:name])
    expect(result[:data][1][:attributes][:name]).to eq(@poster_2[:name])
  end

  it "returns empty array when query parameter are not met" do

    get "/api/v1/posters?name=asdfghjkl"

    expect(response).to be_successful
    result = JSON.parse(response.body, symbolize_names: true)
    expect(result[:data]).to eq([])

    get "/api/v1/posters?min_price=2000"

    expect(response).to be_successful
    results = JSON.parse(response.body, symbolize_names: true)
    expect(results[:data]).to eq([])
    
    get "/api/v1/posters?max_price=1"

    expect(response).to be_successful
    results = JSON.parse(response.body, symbolize_names: true)
    expect(results[:data]).to eq([])
  end
end

