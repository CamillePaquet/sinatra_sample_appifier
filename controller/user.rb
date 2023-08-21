Application::PPAService.get '/password/update' do
  if User.find_by(username: get_user_username).temporary_password
    render_erb view: :'user/update_password'
  else
    redirect '/'
  end
end

Application::PPAService.post '/password/update' do
  user = User.find_by(username: get_user_username)
  user.update_attribute('password', params['password'])
  user.update_attribute('temporary_password', false)
  redirect '/'
end

Application::PPAService.get '/profile/update' do
  @user = User.find_by(username: get_user_username)
  render_erb view: :'user/update_profile'
end

Application::PPAService.post '/profile/update' do
  user = User.find_by(username: get_user_username)
  data = params['password'].empty? ? params.delete('password') : params
  user.update_attributes!(params)
  redirect '/'
end
