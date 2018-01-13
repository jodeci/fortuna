# frozen_string_literal: true
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def not_found
    raise ActionController::RoutingError, "Not Found"
  end
end
