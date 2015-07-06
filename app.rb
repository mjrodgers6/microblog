require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'sinatra/reloader'
require 'rack-flash'
require 'bundler/setup'

set :database, "sqlite3:microblog.sqlite3"
enable :sessions

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
  erb :signup
end

post '/sign-up' do
  confirmation = params[:confirm_password]

  if confirmation == params[:user][:password]
    @user = User.create(params[:user])
    "SIGNED UP #{@user.username}"
  else
    "Your password and confirmation did not match. Try Again."
  end
end

get '/sign-in' do
  erb :signin
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

get '/feed' do
  @posts = Post.all

  erb :feed
end



get '/welcome' do  #sign-in should probably send you to /account
#   if current_user
#     erb :welcome 
#   else
#     flash[:notice] = "Please log in"
#     redirect '/'
#   end
# end