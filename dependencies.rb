# stdlib
require 'yaml'
require 'json'
require 'singleton'
require 'bcrypt'

# gems
require 'sinatra/namespace'
require 'prometheus/client'
require 'mongoid'
require 'mongo'
require 'prometheus/middleware/collector'
require 'prometheus/middleware/exporter'
require 'sinatra/flash'
require 'redis'
require 'redis-store'
require 'redis-rack'
require 'carioca'
require 'sass/plugin/rack'

# internals PRE
require_relative 'helpers/init'
require_relative 'lib/prometheus'
require_relative 'lib/auth'
require_relative 'lib/menu_manager'
require_relative 'lib/layout_manager'
require_relative 'lib/route_guard'

