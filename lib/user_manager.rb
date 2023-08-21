module %%APPLICATION%%
  class UserManager
    def initialize(session:)
      @session = session
    end

    def get_logged_user
      @user = %%APPLICATION%%::Models::User.find_by(fullname: @session['user_fullname']) unless @session.empty?
    end

    def logged_in?
      @session['auth'] ? true : false
    end

    def get_token
      @session['token'] || nil
    end

    def get_fullname
      @session['user_fullname'] || nil
    end

    def get_username
      @session['user_username'] || nil
    end
  end
end
