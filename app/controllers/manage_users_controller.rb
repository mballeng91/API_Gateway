class ManageUsersController < ApplicationController
    USERS_MS = "http://192.168.99.101:3001/"
    def createUser
        options = {
            :body => {
                :user => {
                    :first_name => params[:first_name],
                    :last_name => params[:last_name],
                    :email => params[:email],
                    :age => params[:age],
                    :password => params[:password],
                    :password_confirmation => params[:password_confirmation],
                }
            }.to_json,
            :headers => {
                'Content-Type' => 'application/json'
            }
        }
        result = HTTParty.post(USERS_MS + "users", options)
        if result.code == 201
            render json: {
                message: "El usuario se creó correctamente",
                user: JSON.parse(result.body)
            }, status: :created
        else
            render json: {
                message: "Ocurrió un error al crear el usuario",
                errors: JSON.parse(result.body)
            }, status: :bad_request
        end
    end

    def updateUser
        options = {
            :body => params[:manage_user],
            :headers => {
                'Content-Type' => 'application/json',
                'Authorization' => request.headers["Authorization"]
            }
        }
        puts options
        result = HTTParty.put(USERS_MS + "users/" + params[:id], options)
        if result.code == 200
            render json: {
                message: "El usuario se creó correctamente",
                user: JSON.parse(result.body)
            }, status: :ok
        else
            render json: {
                message: "Ocurrió un error al modificar el usuario",
                errors: JSON.parse(result.body)
            }, status: :bad_request
        end
    end
end
