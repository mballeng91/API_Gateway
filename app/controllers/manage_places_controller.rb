class ManagePlacesController < ApplicationController
    USERS_MS = "http://192.168.99.101:3000/"
    PLACES_MS = "http://192.168.99.101:3006/"

    def getPlaces
        result = HTTParty.get(PLACES_MS + "places")
        if result.code == 200
            render json: {
                sites: JSON.parse(result.body),
            }, status: :ok
        else
            render json: {
                message: "Ocurrió un error al obtener los sitios",
                errors: JSON.parse(result.body),
            }, status: :bad_request
        end
    end
end
