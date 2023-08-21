require_relative 'dependencies'

# initializing Light Weight Application Services registry
Carioca::Registry.configure do |spec|
  spec.init_from_file = false
  spec.debug = true if ENV['DEBUG']
  spec.log_file = '/dev/null' if defined?(Rake) or defined?(RSpec)
  spec.config_file = './config/settings.yml'
  spec.config_root = :application
  spec.environment = ENV['RACK_ENV'] ? ENV['RACK_ENV'].to_sym : :development
  spec.default_locale = :fr
  spec.locales_load_path << Dir[File.expand_path('./config/locales') + '/*.yml']
end

include %%APPLICATION%%::Helpers::Config
include %%APPLICATION%%::Helpers::Status
include %%APPLICATION%%::Helpers::Metrics
include %%APPLICATION%%::Helpers::Display
include %%APPLICATION%%::Helpers::Token
include %%APPLICATION%%::Helpers::User
include %%APPLICATION%%::Helpers::I18n
include %%APPLICATION%%::Helpers::ServicesCheckers
include %%APPLICATION%%::Helpers::RouteGuard

Sass::Plugin.options[:style] = :compressed

module %%APPLICATION%%
  # initialize Application Controller
  class Controller < Carioca::Container
    inject service: :configuration
    inject service: :i18n
    logger.info(to_s) { 'starting Service' }
  end

  # Sinatra modular Application definition
  class %%NAMESPACE%% < Sinatra::Base
    set :raise_errors, false
    set :show_exceptions, false
    register Sinatra::Namespace
    register Sinatra::Flash
    include %%APPLICATION%%::Metrics

    helpers do
      include Sinatra::Authorization::Helpers
    end

    use Sass::Plugin::Rack
    use Rack::Session::Redis, redis_server: %%APPLICATION%%::Controller.configuration.settings.redis.url
  end
end

%%APPLICATION%%::Controller.logger.fatal('Backends not available') && exit(10) unless backend_available?

Mongoid.configure do |config|
  config.clients.default = {
    uri: %%APPLICATION%%::Controller.configuration.settings.mongodb.url
  }
  config.belongs_to_required_by_default = false
end

# internals POST
require_relative 'models/init'
require_relative 'serializer/init'
require_relative 'routes/prepare'
require_relative 'controller/prepare'
require_relative 'lib/user_manager'

include %%APPLICATION%%::Serializer
include %%APPLICATION%%::Models

%%APPLICATION%%::Controller.logger.info(to_s) { 'Ready to serve' }

notify unless defined?(Rake) or defined?(RSpec)