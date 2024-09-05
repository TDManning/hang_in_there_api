class Api::V1::PostersController < ApplicationController
    def index
        posters = Poster.all
        render json: PosterSerializer.new(posters) 
    end

    def show
        poster = Poster.find(params[:id])
        render json: PosterSerializer.new(poster)
    end
    
end