require 'sinatra'
require 'sinatra/activerecord'
# require 'sinatra/reloader'
require './models'
require 'rack-flash'
require 'bundler/setup'


set :database, "sqlite3:microblog.sqlite3"
set :sessions, true 

configure(:development){set :database, "sqlite3:microblog.sqlite3"}

use Rack::Flash, sweep: true


def current_user
  if session[:user_id]
    @user= User.find session[:user_id]
  else
    nil
  end
end


get '/' do
  if current_user
    redirect '/profile'
  else
    redirect '/sign-in'
  end
end

get "/profile/:user_id" do
  @user = User.find(params[:user_id])
  erb :profile
end

get '/profile' do
  @user = current_user if current_user
  erb :profile
end

get '/sign-up' do 
  erb :signup, :layout => false
end

post '/sign-up' do
  confirmation = params[:confirm_password]

  if confirmation == params[:user][:password]

    @user=User.find_by(params[:user])
    flash[:notice] = "This user exists already"
    erb :signup
  elsif
    confirmation == params[:user][:password]
    @user = User.create(params[:user])       
    @user.create_profile(params[:profile])
    flash[:notice] = "Welcome to Stream! Now your life is awesome!"
    session[:user_id] = @user.id
    redirect '/profile'
  else
    flash[:alert] = "Your password and username don't match"

  end
end

get '/sign-in' do
  erb :signinup, :layout => false
end

post "/sign-in" do
  @user = User.where(username: params[:username]).last
  
  
  if @user && @user.password == params[:password]
    flash[:notice] = "You've successfully logged in."
    session[:user_id] = @user.id
    params = nil
    redirect '/profile'
  else
    flash[:notice] = "Wrong login info, please try again"
    redirect '/'
  end
end


get '/settings' do
  @user = current_user
  if current_user
    erb :settings
  else
    redirect '/sign-in'
  end
end

get '/signout' do

  session[:user_id] = nil
  flash[:notice] = "Signed Out Successfully.  Come back soon!"
  redirect '/'
end

# get '/post' do
#   erb :post
# end

# get '/feed' do
#   @posts = Post.all

#   erb :feed
# end
get '/settings' do
  erb :settings
end

post '/account_delete' do
  previous_account = (session[:user_id])
  session[:user_id] = nil
  User.find(previous_account).destroy
  flash[:deleted_account] = "Your account #{previous_account} has been deleted."
  redirect '/'
end

post '/change_info' do
  if params[:user][:fname] != ''
    current_user.update(fname: params[:user][:fname])
  end
  if params[:user][:lname] != ''
    current_user.update(lname: params[:user][:lname])
  end
  if params[:user][:email] != ''
    current_user.update(email: params[:user][:email])
  end
  if params[:user][:username] != ''
    current_user.update(username: params[:user][:username])
  end
  if params[:user][:password] != ''
    current_user.update(password: params[:user][:password])
  end
  if params[:profile][:location] != ''
    current_user.profile.update(location: params[:profile][:location])
  end
  if params[:profile][:occupation] != ''
    current_user.profile.update(occupation: params[:profile][:occupation])
  end
  if params[:profile][:age] != ''
    current_user.profile.update(age: params[:profile][:age])
  end
  redirect '/'
end

post '/post_feed' do
  if params[:user][:feed] != ''
    current_user.posts.create(posttext: params[:user][:feed])
  end
  redirect '/profile'
end

