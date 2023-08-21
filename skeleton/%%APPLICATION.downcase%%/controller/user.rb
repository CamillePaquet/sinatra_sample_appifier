%%APPLICATION%%::%%NAMESPACE%%.get '/password/update' do
  if User.find_by(username: get_user_username).temporary_password
    render_erb view: :'user/update_password'
  else
    redirect '/'
  end
end

%%APPLICATION%%::%%NAMESPACE%%.post '/password/update' do
  user = User.find_by(username: get_user_username)
  user.update_attribute('password', params['password'])
  user.update_attribute('temporary_password', false)
  redirect '/'
end

%%APPLICATION%%::%%NAMESPACE%%.get '/profile/update' do
  @user = User.find_by(username: get_user_username)
  render_erb view: :'user/update_profile'
end

%%APPLICATION%%::%%NAMESPACE%%.post '/profile/update' do
  user = User.find_by(username: get_user_username)
  data = params['password'].empty? ? params.delete('password') : params
  user.update_attributes!(params)
  redirect '/'
end
