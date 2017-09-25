Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/sign-in', to: 'authenticate#authUser'

  post '/events/create', to: 'manage_events#createEvent'
  post '/events/:event_id/invite', to: 'manage_events#inviteUsers'
  get '/events/', to: 'manage_events#getEvents'
  get '/events/:event_id/attendance', to: 'manage_events#getEventWithAttendance'

  post '/users/create', to: 'manage_users#createUser'
  put '/users/update/:id', to: 'manage_users#updateUser'

  post '/attendance/:event_id', to: 'manage_events#defineAttendance'
end
