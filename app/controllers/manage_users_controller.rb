class ManageUsersController < ApplicationController
    USERS_MS = "http://192.168.99.101:3000/"
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
        if current_user = checkToken(request.headers["Authorization"])
            options = {
                :body => params[:user],
                :headers => {
                    'Content-Type' => 'application/json',
                    'Authorization' => request.headers["Authorization"]
                }
            }
            result = HTTParty.put(USERS_MS + "users/" + current_user["id"], options)
            if result.code == 200
                render json: {
                    message: "El usuario se modificó correctamente",
                    user: JSON.parse(result.body)
                }, status: :ok
            else
                render json: {
                    message: "Ocurrió un error al modificar el usuario",
                    errors: JSON.parse(result.body)
                }, status: :bad_request
            end
        else
            render json: {
                message: "Necesita de un token para realizar las peticiones",
            }, status: :unauthorized
        end
    end

    def deleteUser
        if current_user = checkToken(request.headers["Authorization"])
            result = HTTParty.delete(USERS_MS + "users/" + current_user["id"])
            if result.code == 200
                render json: {
                    message: "El usuario se eliminó correctamente",
                    user: JSON.parse(result.body)
                }, status: :ok
            else
                render json: {
                    message: "Ocurrió un error al eliminar el usuario",
                    errors: JSON.parse(result.body)
                }, status: :bad_request
            end
        else
            render json: {
                message: "Necesita de un token para realizar las peticiones",
            }, status: :unauthorized
        end
    end

    def checkToken(token)
        options = {
            :headers => {
                'Accept' => 'application/json',
                'Authorization' => token
            }
        }
        result = HTTParty.get(USERS_MS + "test", options)

        if result.code == 200
            return result
        else
            render json: {
                message: "El token no es valido o ya expriró",
            }, status: :unauthorized
        end
    end
end
