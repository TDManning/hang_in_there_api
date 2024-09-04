class Api::V1::PostersController < ApplicationController
    def index
        render json: {
            test_key: "test value"
        }
    end
end