class ManageEventsController < ApplicationController
    USERS_MS = "http://192.168.99.101:3000/"
    EVENTS_MS = "http://192.168.99.101:3006/"
    INVITES_MS = "http://192.168.99.101:3005/"
    ATTENDANCE_MS = "http://192.168.99.101:3004/"

    def createEvent
        if request.headers.include? "Authorization"
            if current_user = checkToken(request.headers["Authorization"])
                options = {
                    :body => {
                        :name => params[:name],
                        :description => params[:description],
                        :address => params[:address],
                        :phone => params[:phone],
                        :start_time => params[:start_time],
                        :end_time => params[:end_time],
                        :latitude => params[:latitude],
                        :longitude => params[:longitude],
                        :owner_id => current_user["id"]
                    }.to_json,
                    :headers => {
                        'Content-Type' => 'application/json'
                    }
                }
                result = HTTParty.post(EVENTS_MS + "eventms", options)
                if result.code == 201
                    render json: {
                        message: "El evento se creó correctamente",
                        user: JSON.parse(result.body)
                    }, status: :created
                else
                    render json: {
                        message: "Ocurrió un error al crear el evento",
                        errors: JSON.parse(result.body)
                    }, status: :bad_request
                end
            end
        else
            render json: {
                message: "Necesita de un token para realizar las peticiones",
            }, status: :unauthorized
        end
    end

    def getEvents
        if request.headers.include? "Authorization"
            if current_user = checkToken(request.headers["Authorization"])
                result = HTTParty.get(EVENTS_MS)
                if result.code == 200
                    render json: {
                        events: JSON.parse(result.body),
                    }, status: :ok
                else
                    render json: {
                        message: "Ocurrió un error al obtener los eventos",
                        errors: JSON.parse(result.body)
                    }, status: :bad_request
                end
            end
        else
            render json: {
                message: "Necesita de un token para realizar las peticiones",
            }, status: :unauthorized
        end
    end

    def inviteUsers
        if request.headers.include? "Authorization"
            if current_user = checkToken(request.headers["Authorization"])
                if event = checkEvent(params[:id])
                    options = {
                        :body => {
                            :Invita => {
                                :ID => current_user["id"],
                                :Email => current_user["email"]
                            },
                            :Evento => {
                                :ID => event["id"],
                                :Name => event["name"],
                                :Date => event["startTime"],
                                :Hour => event["startTime"],
                                :Place => event["address"],
                            },
                            :Invitados => [params[:invites]]
                        }.to_json,
                        :headers => {
                            'Content-Type' => 'application/json'
                        }
                    }
                    result = HTTParty.post(INVITES_MS + "api/invitaciones/", options)
                    if result.code == 200
                        render json: {
                            message: "Se invitaron los usuarios correctamente",
                        }, status: :ok
                    else
                        render json: {
                            message: "Ocurrió un error al invitar a los usuarios",
                            errors: JSON.parse(result.body)
                        }, status: :bad_request
                    end
                else
                    render json: {
                        message: "El evento no existe",
                        errors: JSON.parse(result.body)
                    }, status: :bad_request
                end

            end
        else
            render json: {
                message: "Necesita de un token para realizar las peticiones",
            }, status: :unauthorized
        end
    end

    def getEventWithAttendance
        if request.headers.include? "Authorization"
            if current_user = checkToken(request.headers["Authorization"]) && event = checkEvent(params[:event_id])
                attendance = getAttendance(params[:event_id])
                invitations = getInvitations(params[:event_id])
                render json: {
                    event: JSON.parse(event.body),
                    invitations: JSON.parse(invitation.body),
                    attendance: JSON.parse(attendance.body)
                }, status: :ok
            end
        end
    end

    def defineAttendance
        if request.headers.include? "Authorization"
            if current_user = checkToken(request.headers["Authorization"]) && event = checkEvent(params[:event_id])
                options = {
                    :body => {
                        :user_id => current_user["id"],
                        :event_id => event["id"],
                        :status => params[:status]
                    }.to_json,
                    :headers => {
                        'Content-Type' => 'application/json'
                    }
                }
                result = HTTParty.post(ATTENDANCE_MS + "attendance", options)
                if result.code == 200
                    render json: {
                        message: "Se cambió el estado de asistencia correctamente",
                    }, status: :ok
                else
                    render json: {
                        message: "Ocurrió un error al asignar la asistencia",
                        errors: JSON.parse(result.body)
                    }, status: :bad_request
                end
            end
        end
    end

    def getAttendance(id)
        result = HTTParty.get(ATTENDANCE_MS + id.to_s)
        return result
    end

    def getInvitations(id)
        result = HTTParty.get(INVITES_MS + id.to_s)
        return result
    end

    def checkEvent(id)
        result = HTTParty.get(EVENTS_MS + id.to_s)
        if result.code == 200
            return result
        else
            render json: {
                message: "El evento no existe o ya expiró",
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
