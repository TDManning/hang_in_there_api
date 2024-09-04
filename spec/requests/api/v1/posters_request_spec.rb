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

    poster = JSON.parse(response.body, symbolize_names: true)

    expect(poster.count).to eq(3)

    # posters.each do |poster|
    #   expect(song).to have_key(:id)
    #   expect(song[:id]).to be_an(Integer)

    #   expect(song).to have_key(:title)
    #   expect(song[:title]).to be_a(String)

    #   expect(song).to have_key(:length)
    #   expect(song[:length]).to be_a(Integer)

    #   expect(song).to have_key(:play_count)
    #   expect(song[:play_count]).to be_a(Integer)
    # end
  end
end
