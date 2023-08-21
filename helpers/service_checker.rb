module Application
  module Helpers
    module ServicesCheckers
      def check_mongodb
        res = {}
        begin
          client = Mongo::Client.new(Application::Controller.configuration.settings.mongodb.url)
          client.database_names
          res[:status] = 'OK'
        rescue Mongo::Auth::Unauthorized, Mongo::Error => e
          res[:status] = 'KO'
          res[:message] = "Error #{e.class}: #{e.message}"
        end
        res 
      end
      
      def check_redis
        res = {}
        begin
          redis = Redis.new(url: Application::Controller.configuration.settings.redis.url)
          redis.keys('*')
          res[:status] = 'OK'
        rescue Redis::CannotConnectError => e
          res[:status] = 'KO'
          res[:message] = "Error #{e.class}: #{e.message}"
        end
        res
      end
      
      
      def backend_available?
        return false if check_mongodb[:status] == 'KO'
        return false if check_redis[:status] == 'KO'
        return true
      end
    end
  end
end