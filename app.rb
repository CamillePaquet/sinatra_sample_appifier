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

include Application::Helpers::Config
include Application::Helpers::Status
include Application::Helpers::Metrics
include Application::Helpers::Display
include Application::Helpers::Token
include Application::Helpers::User
include Application::Helpers::I18n
include Application::Helpers::ServicesCheckers
include Application::Helpers::RouteGuard

Sass::Plugin.options[:style] = :compressed

module Application
  # initialize Application Controller
  class Controller < Carioca::Container
    inject service: :configuration
    inject service: :i18n
    logger.info(to_s) { 'starting Service' }
  end

  # Sinatra modular Application definition
  class PPAService < Sinatra::Base
    set :raise_errors, false
    set :show_exceptions, false
    register Sinatra::Namespace
    register Sinatra::Flash
    include Application::Metrics

    helpers do
      include Sinatra::Authorization::Helpers
    end

    use Sass::Plugin::Rack
    use Rack::Session::Redis, redis_server: Application::Controller.configuration.settings.redis.url
  end
end

Application::Controller.logger.fatal('Backends not available') && exit(10) unless backend_available?

Mongoid.configure do |config|
  config.clients.default = {
    uri: Application::Controller.configuration.settings.mongodb.url
  }
  config.belongs_to_required_by_default = false
end

# internals POST
require_relative 'models/init'
require_relative 'serializer/init'
require_relative 'routes/prepare'
require_relative 'controller/prepare'
require_relative 'lib/user_manager'

include Application::Serializer
include Application::Models

Application::Controller.logger.info(to_s) { 'Ready to serve' }

notify unless defined?(Rake) or defined?(RSpec)