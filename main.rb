require 'sinatra'
require 'sinatra/reloader' if development?
require 'slim'
require './song'

set :public_folder, 'assets'

configure do
  enable :sessions
  set :username, 'thuan.nd'
  set :password, '1234'
end

get "/login" do
  slim :login
end

post "/login" do
  if params[:username] == settings.username && params[:password] == settings.password
    session[:admin] = true
    redirect to('/songs')
  else
    slim :login
  end
end

get '/logout' do
  session.clear
  redirect to('/login')
end

get "/" do
  slim :home
end

get "/about" do
  @title = "About"
  slim :about
end

get "/contact" do
  slim :contact
end

get "/songs" do
  @title = "All Songs"
  slim :songs 
end

not_found do
  slim :not_found
end