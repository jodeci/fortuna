# frozen_string_literal: true
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def store_location
    session[:return_to] = request.fullpath if request.get?
  end

  private

  def not_found
    raise ActionController::RoutingError, "Not Found"
  end
end
