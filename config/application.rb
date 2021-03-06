# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'active_record/railtie'
require 'action_controller/railtie'

Bundler.require(*Rails.groups)

module ETicketingSystemAPI
  class Application < Rails::Application
    config.load_defaults 6.0
    config.api_only = true
    config.autoload_paths << Rails.root.join('lib')
  end
end
