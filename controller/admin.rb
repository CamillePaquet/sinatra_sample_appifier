%%APPLICATION%%::%%NAMESPACE%%.get '/admin/user/create' do
  @profiles = get_config.profiles.additional
  @token = generate_token!
  render_erb view: :'admin/create_user'
end

%%APPLICATION%%::%%NAMESPACE%%.post '/admin/user/create' do
  User.create!(
    username: params['username'],
    profiles: params['profiles'].split(',').map(&:to_sym).push(get_config.profiles[:default]),
    token: params['token'],
    temporary_password: true,
    fullname: params['fullname'],
    password: params['password'],
    api_user: params['api_user'],
    email: params['email']
  )
  notify metric: :users 
  redirect '/admin/users'
end

%%APPLICATION%%::%%NAMESPACE%%.get '/admin/user/update/:id' do |id|
  @user = User.find(id)
  @profiles = get_config.profiles.additional
  render_erb view: :'admin/update_user'
end

%%APPLICATION%%::%%NAMESPACE%%.post '/admin/user/update/:id' do |id|
  user = User.find(id) if User.where(id: id).exists?
  data = {}
  data['username'] = params['username']
  data['fullname'] = params['fullname']
  data['email'] = params['email']
  data['token'] = params['token']
  data['api_user'] = params['api_user']
  data['profiles'] = [get_config.profiles[:default]]
  unless params['profiles'].split(',').empty?
    params['profiles'].split(',').each do |profile|
      data['profiles'].push profile if get_config.profiles.additional.include? profile.to_sym
    end
  end
  user.update_attributes!(data)
  user.save!
  redirect '/admin/users'
end

%%APPLICATION%%::%%NAMESPACE%%.get '/admin/users' do
  @users = User.all
  render_erb view: :'admin/list_users'
end

%%APPLICATION%%::%%NAMESPACE%%.post '/admin/user/delete/:id' do |id|
  if User.where(id: id).exists?
    user = User.find(id)
    user.delete
    notify metric: :users 
  end
  redirect '/admin/users'
end

%%APPLICATION%%::%%NAMESPACE%%.get '/admin/message/create' do
  @types = get_config.messages.types
  @users = User.all
  render_erb view: :'admin/create_message'
end

%%APPLICATION%%::%%NAMESPACE%%.post '/admin/message/create' do
  if params['global']
    User.all.each do |user|
      message = Message.create!(
        title: params['title'],
        content: params['content'],
        type: params['type']
      )
      user.messages.push(message) 
    end
  else
    params['users'].split(',').each do |user|
      if User.where(username: user).exists?
        message = Message.create!(
          title: params['title'],
          content: params['content'],
          type: params['type']
        )
        User.find_by(username: user).messages.push(message) 
      end
    end
  end
  redirect '/'
end