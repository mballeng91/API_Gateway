class AuthenticateController < ApplicationController
    def authUser()
        options = {
            :body => {
                :email => params[:email],
                :password => params[:password]
            }.to_json,
            :headers => {
                'Content-Type' => 'application/json'
            }
        }
        result = HTTParty.post("http://192.168.99.101:3001/authenticate", options)
        if result["token"]
            render json: {
                token: result["token"],
            }, status: :ok
        else
            render json: {
                message: "Usuario y/ó contraseña invalidos",
            }, status: :unauthorized
        end
    end
end
