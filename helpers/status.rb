module Application
  module Helpers
    module Status
      def get_status_from_map(key: nil)
        return get_config.status[key] if key  
      end
      
      
      def get_status_key_by(exception: nil)
        keys = []
        get_config.status.each do |key, value|  
          if value.include? :exceptions
            keys.push key if value[:exceptions].include? exception
          end
        end
        return keys.first
      end
      
      def get_status_code(option = {})
        return get_status_from_map(key: option[:key])[:code]
      end
      def get_status_description(option = {})
        return get_status_from_map(key: option[:key])[:description]
      end
      def get_status_ruby(option = {})
        status = get_status_from_map(key: option[:key])
        status.delete(:name)
        return status
      end
      def get_status_json(option = {})
        return get_status_ruby(option).to_json
      end

      class SpecificError < Exception
        attr_reader :status_key
        def initialize(*arg, status_key: :error_system)
          super(*arg)
          @status_key = status_key
        end
      end
      
      def secure_api_return(data: nil, status_key: nil, structured: false )
        begin
          data = yield if block_given?
          res = (structured)? get_status_ruby(key: status_key).merge({data: data }) : data
          
          status get_status_code(key: status_key)
          return JSON.pretty_generate(JSON.parse(res.to_json))
        rescue SpecificError => e
          status get_status_code(key: e.status_key)
          error = get_status_ruby(key: e.status_key)
          error.delete(:exceptions) if error.include? :exceptions
          return error.to_json
        rescue Exception => e
          key = get_status_key_by exception: e.class.to_s
          key = (key)? key : :error_system
          status get_status_code(key: key)
          error = get_status_ruby(key: key)
          error.delete(:exceptions) if error.include? :exceptions
          error[:description] = "#{e.class.to_s} : #{e.message}"
          return error.to_json
        end
      end
      
    end
  end
end
