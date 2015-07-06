require 'sinatra'
require 'sinatra/activerecord'
# require 'sinatra/reloader'
require './models.rb'
require 'rack-flash'
require 'bundler/setup'


set :database, "sqlite3:microblog.sqlite3"
enable :sessions

configure(:development){set :database, "sqlite3:microblog.sqlite3"}

use Rack::Flash, sweep: true


def current_user
  if session[:user_id]
    User.find session[:user_id]
  end
end


get '/' do
  if current_user
    redirect '/profile'
  else
    redirect '/sign-in'
  end
end

get '/sign-up' do 
  erb :signup, :layout => false
end

post '/sign-up' do
  confirmation = params[:confirm_password]

  if confirmation == params[:user][:password]
    @user = User.create(params[:user])       
    @user.create_profile(params[:profile])
    flash[:notice] = "Welcome to Stream! Now your life is awesome!"
    redirect '/profile'
  else
    flash[:alert] = "Your password and username don't match"
  end
end

get '/sign-in' do
  erb :signin, :layout => false
end

post "/sign-in" do
  username = params[:username]
  password = params[:password]

  @user = User.where(username: username).first

  if @user.password == password
    session[:user_id] = @user.id
    flash[:notice] = "Welcome #{@user.username}!"
    redirect '/welcome'
  else
    flash[:notice] = "Wrong login info, please try again"
    redirect '/'
  end
end


get '/account' do
  @user = current_user
  if current_user
    erb :account
  else
    redirect '/sign-in'
  end
end

get '/signout' do

  session[:user_id] = nil
  flash[:notice] = "Signed Out Successfully.  Come back soon!"
  redirect '/'
end

get '/feed' do
  @posts = Post.all

  erb :feed
end
