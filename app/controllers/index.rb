enable :sessions

get '/' do
  erb :index
end

get '/login' do
  session[:admin] = true
  redirect to("/auth/twitter")
end
 
get '/auth/twitter/callback' do
  env['omniauth.auth'] ? session[:admin] = true : halt(401,'Not Authorized')
  @user = TwitterUser.find_or_created_by_username(env['omniauth.auth'])
  session[:username] = @user.username
  redirect '/'
end


post '/tweet' do
  halt(401,'Not Authorized') unless admin?
  @user = TwitterUser.find_by(username: session[:username])
  job_id = @user.post_tweet(params[:a])
end

get '/tweets' do
  halt(401,'Not Authorized') unless admin?
  @user = TwitterUser.find_by(username: session[:username])
  @tweets = @user.fetch_tweets
  erb :show, layout: false
end

post '/tweet_later' do
  halt(401,'Not Authorized') unless admin?
  @user = TwitterUser.find_by(username: session[:username])
  # byebug
  job_id = @user.post_tweet_later(params[:b], params[:time])
end
 
#LEARNING PORTAL
get '/status/:job_id' do
  @job_id = params[:job_id]
  job_is_complete(params[:job_id]).to_s
end



get '/auth/failure' do
  params[:message]
end

get '/logout' do
  session.clear
  redirect '/'
end

