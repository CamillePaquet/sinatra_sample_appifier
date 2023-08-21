module Application
  module Serializer
    class StatusSerializer < Hash
      def initialize
        self.merge!({:name => get_config.application.name,
          :version => get_config.version,
          :status => "OK"
         })
        self.merge!({status: "KO" }) unless backend_available?
        self.merge!({backends:  {mongodb: check_mongodb, redis: check_redis} })
      end

     

      

    end
  end
end
