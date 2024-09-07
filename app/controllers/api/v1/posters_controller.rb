class Api::V1::PostersController < ApplicationController
    def index
        if params[:sort] 
            posters = Poster.order(created_at: params[:sort].to_sym)
        elsif params[:name]
            posters = Poster.where("name ILIKE ?", "%#{params[:name]}%")
        else
            posters = Poster.all
        end

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