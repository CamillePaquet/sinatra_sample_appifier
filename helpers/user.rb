module Application
  module Helpers
    module User
      def logged_in?
        Application::UserManager.new(session: session).logged_in?
      end

      def get_token
        Application::UserManager.new(session: session).get_token?
      end

      def get_user_fullname
        Application::UserManager.new(session: session).get_fullname
      end

      def get_user_username
        Application::UserManager.new(session: session).get_username
      end
    end
  end
end
