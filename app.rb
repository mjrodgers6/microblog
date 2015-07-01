require 'sinatra'
require 'sinatra/activerecord'
require './models'
require 'sinatra/reloader'

set :database, "sqlite3:microblog.sqlite3"

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