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

    def update
        poster = Poster.update(params[:id], poster_params)
        render json: PosterSerializer.new(poster)
    end

    def destroy
        head :no_content
    end
    
    private 
    
    def poster_params
        params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url)
    end
end