module %%APPLICATION%%
  module Helpers
    module Metrics
      def notify(**keywords)
        %%APPLICATION%%::Metrics::Notifier.instance.notify **keywords
      end
    end
  end
end
