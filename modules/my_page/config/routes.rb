#-- encoding: UTF-8



OpenProject::Application.routes.draw do
  get '/my/page', to: 'angular#empty_layout'
end
