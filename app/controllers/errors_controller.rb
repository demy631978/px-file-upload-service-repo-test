class ErrorsController < ApplicationController
  def not_found
    error_response({ errors: 'endpoint doesn\'t exist or missing path variable value' }, :not_found)
  end
end