require 'rack/tidy'

Rails.application.config.middleware.use Rack::Tidy
