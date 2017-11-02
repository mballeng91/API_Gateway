class ManagePlacesController < ApplicationController
    USERS_MS = "http://192.168.99.101:3001/"
    PLACES_MS = "http://192.168.99.101:3002/"

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

    def getPlacesById
         result = HTTParty.get(EVENTS_MS + "places/"  + params[:place_id].to_s)
         if result.code == 200
             return result
         else
             render json: {
                 message: "El sitio con id: " + params[:place_id].to_s + "no existe",
                 token: current_user.header['jwt']
             }, status: :not_found
         end
     end

end
