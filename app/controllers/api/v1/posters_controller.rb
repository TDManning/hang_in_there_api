class Api::V1::PostersController < ApplicationController
    def index
        posters = Poster.all
        render json: PosterSerializer.new(posters) 
    end

    def show
        poster = Poster.find(params[:id])
        render json: PosterSerializer.new(poster)
    end
    
    def create
        poster = Poster.create(poster_params)
        render json: PosterSerializer.new(poster)
    end

    def poster_params
        params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url)
    end
end