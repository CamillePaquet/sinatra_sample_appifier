module %%APPLICATION%%
  class LayoutManager
    def initialize(path:, method:)
      @path = path
      @method = method
      @definitions = get_config.routes.definitions
    end

    def negociate
      matched_routes = {}
      matched_routes = @definitions[@method].select { |definition| Mustermann.new(definition[:route]) =~ @path } unless @definitions[@method].nil?
      return :layout if matched_routes.empty?
      return matched_routes.first.include?(:layout) ? matched_routes.first[:layout] : :layout
    end
  end
end
