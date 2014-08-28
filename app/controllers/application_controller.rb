class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # protect_from_forgery with: :exception
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  # TODO: Add authentication
  # TODO: Update sdr-pc config with authentication config, see
  # TODO: sdr-preservation-core/config/environments/integration.rb

end
