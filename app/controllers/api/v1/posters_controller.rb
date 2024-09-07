class Api::V1::PostersController < ApplicationController
    def index
        posters = Poster.all

        posters = posters.sorted_by_created_at(params[:sort]) if params[:sort]
        posters = posters.filtered_by_name(params[:name]) if params[:name]
        posters = posters.filtered_by_min_price(params[:min_price]) if params[:min_price]
        posters = posters.filtered_by_max_price(params[:max_price]) if params[:max_price]

        metaObject = {
            meta: {count: posters.count}
        }
        
        render json: PosterSerializer.new(posters, metaObject) 
    end

    def show
        poster = Poster.find(params[:id])
        render json: PosterSerializer.new(poster)
    end
    
    def create
        poster = Poster.create(poster_params)
        render json: PosterSerializer.new(poster)
    end

    def update
        poster = Poster.update(params[:id], poster_params)
        render json: PosterSerializer.new(poster)
    end

    def destroy
        poster = Poster.find(params[:id])
        poster.destroy
        head :no_content
    end
    
    private 
    
    def poster_params
        params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url)
    end
end