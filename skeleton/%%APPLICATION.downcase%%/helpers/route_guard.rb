module %%APPLICATION%%
  module Helpers
    module RouteGuard
      def check_route(user_id:, path:, method:)
        guard = %%APPLICATION%%::RouteGuard.new
        guard.check(user_id: user_id, path: path, method: method)
      end

      def check_path_access_request_auth(path:, method:)
        guard = %%APPLICATION%%::RouteGuard.new
        guard.path_access_request_auth(path: path, method: method)
      end
    end
  end
end
