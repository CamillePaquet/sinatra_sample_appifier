module %%APPLICATION%%
  module Helpers
    module User
      def logged_in?
        %%APPLICATION%%::UserManager.new(session: session).logged_in?
      end

      def get_token
        %%APPLICATION%%::UserManager.new(session: session).get_token?
      end

      def get_user_fullname
        %%APPLICATION%%::UserManager.new(session: session).get_fullname
      end

      def get_user_username
        %%APPLICATION%%::UserManager.new(session: session).get_username
      end
    end
  end
end
