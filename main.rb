require 'sinatra'
require 'sinatra/reloader' #if development?
require 'sinatra/flash'
require 'slim'
require 'sass'
require 'v8'
require 'coffee-script'
require './song'
require './sinatra/auth'


#config
set :public_folder, 'assets'

get('/css/style.css'){ scss :styles }
get('/javascripts/application.js'){ coffee :application }


configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

#helper
helpers do
  def css(*stylesheets)
    stylesheets.map do |stylesheet|
      "<link href=\"/css/#{stylesheet}.css\" media=\"screen, projection\" rel=\"stylesheet\" />"
    end.join
  end

  def current?(path='/')
    (request.path==path || request.path==path+'/') ? "current" : nil
  end

  def set_title
    @title ||= "Songs by Sinatra"
  end
  def send_message
    "From: #{params[:name]} < #{params[:email]} >
    - Subject: #{params[:name]} has contacted you
    - Body: #{params[:message]}"
  end
end

#before block will be run before each request
before do
  set_title
end

#route
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

post '/contact' do
  flash[:notice] = send_message + "<br/>Thank you for your message. We'll be in touch soon."
  redirect to('/')
end

get "/songs" do
  @title = "All Songs"
  slim :songs 
end

not_found do
  slim :not_found
end
