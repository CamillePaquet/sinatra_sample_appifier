module Application
  module Helpers
    module Metrics
      def notify(**keywords)
        Application::Metrics::Notifier.instance.notify **keywords
      end
    end
  end
end
