module Sinatra
  module Authorization
    class ProtectedAction

      attr_reader :realm, :context

      def initialize(context, realm)
        @realm, @context = realm, context
      end

      def check!
        unauthorized! unless auth.provided?
        bad_request! unless auth.basic?
        unauthorized! unless authorize(*auth.credentials)
      end

      def remote_user
        auth.username
      end

      private

      def authorize(username, password)
         begin
          user = User.find_by(username: username)
          if user and user.api_user? then
            return user.password == password
          else
            return false
          end
        rescue Mongoid::Errors::DocumentNotFound
          return false
        end
      end

      def unauthorized!
        context.headers 'WWW-Authenticate' => %(Basic realm="#{@realm}")
        throw :halt, [ get_status_code(key: :unauthorized), get_status_json(key: :unauthorized) ]
      end

      def bad_request!
        throw :halt, [ et_status_code(key: :error_request), get_status_json(key: :error_request) ]
      end

      def auth
        @auth ||= Rack::Auth::Basic::Request.new(context.request.env)
      end
    end

    module Helpers
      def protect!(realm)
        return if authorized?
        guard = ProtectedAction.new(self, realm)
        guard.check!
        request.env['REMOTE_USER'] = guard.remote_user
      end

      def authorized?
        request.env['REMOTE_USER']
      end
    end
  end
end
