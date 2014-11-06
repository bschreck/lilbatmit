Rails.application.routes.draw do


  root :to => 'guests#index'
  post '/rsvp' => 'guests#rsvp'
  get '/confirmed' => 'guests#show'
  get '/over' => 'guests#over'


end
