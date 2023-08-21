Application::PPAService.get '/login' do
  render_erb view: :login
end

Application::PPAService.post '/login' do
  user = nil
  user_password = nil
  if User.where(username: params[:username]).exists?
    user = User.find_by(username: params[:username])
    user_password = user.password
  end
  if !user.nil? && user_password == params[:password]
    session['auth'] = true
    session['token'] = user.token
    session['user_username'] = user.username
    session['user_fullname'] = user.fullname
    redirect '/'
  else
    session['auth'] = false
    session['token'] = nil
    session['user_username'] = nil
    session['user_fullname'] = nil
    flash[:danger] = translate('user.bad_credentials')
    redirect '/login'
  end
end

Application::PPAService.get '/logout' do
  session['user_username'] = nil
  session['token'] = nil
  session['auth'] = false
  session['user_fullname'] = nil
  redirect '/login'
end

Application::PPAService.get '/profil/update' do
  @user = User.find_by(username: session['user_username'])
  render_erb view: :edit_profil
end

Application::PPAService.post '/profil/update' do
  user = User.find_by(username: session['user_username'])
  new_password = params['password'] unless params['password'].empty?
  confirm_password = params['confirm_password'] unless params['confirm_password'].empty?
  if new_password != confirm_password
    flash[:danger] = translate('user.change_password_failed')
  elsif new_password.nil?
    flash[:danger] = translate('user.empty_password')
  else
    user.update_attributes!(password: new_password)
    user.save!
    flash[:success] = translate('user.change_password_success')
  end
  redirect '/profil/update'
end

Application::PPAService.post '/profil/update/token' do
  user = User.find_by(username: session['user_username'])
  new_token = generate_token!.to_s
  user.update_attributes!(token: new_token)
  user.save!
  flash[:success] = translate('user.new_token_registered')
  redirect '/profil/update'
end
