module Application
  module Helpers
    module Display
      def get_goroco
        version = get_config.version
        base, patch = version.split '-'
        gorocopo = %w[G R C]
        table = base.split('.')
        if patch
          table.push patch
          gorocopo.push 'P'
        end
        table.map! { |item| item = item.length == 1 ? "0#{item}" : item }
        res = ''
        gorocopo.each_with_index { |rank, i| res << rank + table[i] }
        res
      end

      def get_environment
        get_config.stage
      end

      def negociate_layout(path:, method:)
        Application::LayoutManager.new(path: path, method: method).negociate
      end

      def negociate_menu(user_id:, menu: :general)
        Application::MenuManager.new(user_id: user_id, menu: menu).negociate
      end

      def render_erb(view:, layout: nil)
        if layout.nil?
          erb view, layout: negociate_layout(path: instance_variable_get(:@path), method: instance_variable_get(:@method)) 
        else
          erb view, layout: layout
        end
      end

      def is_active?(item)
        get_menu_active == item[:item]
      end
    end
  end
end
