Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/sign-in', to: 'authenticate#authUser'

  post '/events/', to: 'manage_events#createEvent'
  # put '/events/', to: 'manage_events#updateEvent' Implementar
  post '/events/:event_id/invite', to: 'manage_events#inviteUsers'
  get '/events/', to: 'manage_events#getEvents'
  get '/events/:event_id/attendance', to: 'manage_events#getEventWithAttendance'
  post '/events/:event_id/attendance', to: 'manage_events#defineAttendance'  

  post '/users/', to: 'manage_users#createUser'
  # put '/users/', to: 'manage_users#updateUser'
  # delete '/users/', to: 'manage_users#deleteteUser'
  put '/users/update/:id', to: 'manage_users#updateUser'
end
