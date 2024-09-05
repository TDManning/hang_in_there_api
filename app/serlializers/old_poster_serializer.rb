class PosterSerializer
  def self.format_posters(posters)
      result = {
        data: []
      }
      posters.each do |poster|
        result[:data] << 
        {
          id: poster.id,
          type: "poster",
          attributes: {
            name: poster.name,
            description: poster.description,
            price: poster.price,
            year: poster.year,
            vintage: poster.vintage,
            img_url: poster.img_url
          }
        }
      end
    return result
  end
end