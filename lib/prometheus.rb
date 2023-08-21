module  %%APPLICATION%%
  module Metrics
    class Notifier

      include Singleton 

      def initialize
        @prometheus = ::Prometheus::Client.registry
        @metrics = %%APPLICATION%%::Controller.configuration.settings.metrics.each do |metric|
          eval("metric[:proc] = lambda { #{metric[:proc]} } ")
          metric[:labels].each {|label,definition|  eval("definition[:proc] = lambda { #{definition[:proc]} } ") } if metric[:labels]
          labels  = (metric[:labels]) ? metric[:labels].keys : []
          metric[:gauge] = ::Prometheus::Client::Gauge.new metric[:name],  labels: labels ,  docstring: metric[:description]
          @prometheus.register(metric[:gauge])
        end
        
        %%APPLICATION%%::Controller.logger.info(self.to_s) { "Initializing Prometheus Notifier" }

      end

      
      def notify(metric: nil)

        selection = (metric)? @metrics.select {|definition| definition[:name] == metric} : @metrics
        selection.each do |metric|
          labels = {}  
          metric[:labels].each {|label,definition| labels[label] = definition[:proc].call} if metric[:labels]
          metric[:gauge].set metric[:proc].call, labels: labels
        end
      end
    end
    
    def self.included(obj)
      %%APPLICATION%%::Metrics::Notifier.instance 
      obj.use ::Prometheus::Middleware::Collector
      obj.use ::Prometheus::Middleware::Exporter
    end

    private

  end
end
