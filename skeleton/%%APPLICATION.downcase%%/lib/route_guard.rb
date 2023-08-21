module %%APPLICATION%%
  class RouteGuard
    def initialize
      @definitions = get_config.routes.definitions
    end

    def check(user_id:, path:, method:)
      profiles = (user_id)? %%APPLICATION%%::Models::User.find(user_id).profiles : []
      matched_routes = {}
      matched_routes = @definitions[method].select { |definition| Mustermann.new(definition[:route]) =~ path } unless @definitions[method].nil?
      if matched_routes.empty?  then 
        return true
      else
        return true if !matched_routes.first.include? :profiles
        intersection = matched_routes.first[:profiles] & profiles
        return !intersection.empty?
      end
    end

    def path_access_request_auth(path:, method:)
      matched_routes = {}
      unless @definitions[method].nil?
        matched_routes = @definitions[method].select do |definition|
          Mustermann.new(definition[:route]) =~ path
        end
      end
      if matched_routes.empty?
        false
      else
        return false unless matched_routes.first.include? :public

        !matched_routes.first[:public]
      end
    end
  end
end
