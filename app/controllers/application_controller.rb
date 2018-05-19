class ApplicationController < ActionController::API
  include ExceptionHandler

  private
  def authorize_request
    @current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
  end
end
