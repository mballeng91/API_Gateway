Rails.application.routes.draw do
  # Authentication endpoints
  post '/sign-in', to: 'authenticate#authUser'
  get '/logout', to: 'authenticate#logout'


  # Event-related endpoints

  post '/events/', to: 'manage_events#createEvent'
  post '/events/:event_id/invite', to: 'manage_events#inviteUsers'
  get '/events/', to: 'manage_events#getEvents'
  get '/events/:event_id/attendance', to: 'manage_events#getEventWithAttendance'
  get '/events/myEvents', to: 'manage_events#getEventsByOwnerId'
  get '/events/place/:place_id', to: 'manage_events#getEventsByPlace'
  get '/events/myInvitations', to: 'manage_events#getMyInvitations'


  get '/sites', to: 'manage_events#getSites'
  get '/sites/by_id', to: 'manage_events#site_by_id'

  post '/users/', to: 'manage_users#createUser'
  get '/users/myProfile', to: 'manage_users#profile'
  put '/users/update/:id', to: 'manage_users#updateUser'
  get '/users/search', to: 'manage_users#searchUsers'


  put '/events/:event_id/attendance', to: 'manage_events#defineAttendance'


end
