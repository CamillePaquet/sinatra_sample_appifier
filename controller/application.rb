%%APPLICATION%%::%%NAMESPACE%%.before do
  notify metric: :status
  @path = request.path_info
  @method = request.request_method.to_sym
  @infos = []
  @alerts = []
  unless @path =~ %r{^/api}

    if logged_in?
      @user = User.find_by(username: session['user_username'])
      @infos = @user.messages.where(type: 'info')
      @alerts = @user.messages.where(type: 'alert')
      redirect '/password/update' if @user.temporary_password && request.path_info != '/password/update'
    end

    @nav_menu = negociate_menu(user_id: @user ? @user.id : false)
    if !logged_in? && check_path_access_request_auth(path: @path, method: @method)
      flash[:danger] = translate('user.need_registration')
      redirect '/login'
    end

    unless check_route(user_id: @user ? @user.id : false, path: @path, method: @method)
      flash[:danger] = translate('user.bad_profil')
      redirect '/'
    end
    
  end
end

%%APPLICATION%%::%%NAMESPACE%%.not_found do
  status 404
  render_erb view: :'/errors/404', layout: :layout_min
end

%%APPLICATION%%::%%NAMESPACE%%.error 500 do
  status 500
  render_erb view: :'/errors/500', layout: :layout_min
end

