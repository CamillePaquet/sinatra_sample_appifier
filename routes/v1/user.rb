Application::PPAService.namespace '/api/v1' do
  get '/users.?:loading?' do |loading|
    return secure_api_return status_key: :success do
      users = User.all
      data = users.map { |user| UserSerializer.new(model: user, type: loading) }
      data
    end
  end

  get '/user/:username.?:loading?' do |username, loading|
    return secure_api_return status_key: :success do
      user = User.find_by(username: username)
      data = UserSerializer.new(model: user, type: loading)
      data
    end
  end

  post '/user' do
    return secure_api_return status_key: :created_success, structured: true do
      body = request.body.read
      data = JSON.parse(body)
      if User.where(username: data['username']).exists?
        raise Application::Helpers::Status::SpecificError.new(status_key: :error_already_exist)
      else
        user = User.create!(
          username: data['username'],
          profiles: data['profiles'].map(&:to_sym),
          token: data['token'],
          fullname: data['fullname'],
          password: data['password'],
          email: data['email'],
          api_user: (data['api_user'])? data['api_user'] : false
        )
        notify metric: :users 
        user
      end
    end
  end
  

  delete '/user/:username' do |username|
    return secure_api_return status_key: :deleted_success, structured: true do
      user = User.find_by(username: username)
      user.delete
      notify metric: :users 
      user
    end
  end

  put '/user' do
    return secure_api_return status_key: :created_success, structured: true do
      body = request.body.read
      data = JSON.parse(body)
      
      if User.where(username: data['username']).exists?
        user_update = User.find_by(username: data['username'])
        user_update.update_attributes!(data)
        user_update.save!
        notify metric: :users 
        user_update
      else
        user = User.create!(
          username: data['username'],
          profiles: data['profiles'].map(&:to_sym),
          token: data['token'],
          fullname: data['fullname'],
          password: data['password'],
          email: data['email'],
          api_user: (data['api_user'])? data['api_user'] : false
        )
        notify metric: :users 
        user
      end
    end
  end
end
