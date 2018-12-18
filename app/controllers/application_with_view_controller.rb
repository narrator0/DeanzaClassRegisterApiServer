class ApplicationWithViewController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :set_raven_context

  private
  def authorize_request
    @current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
  end

  def set_raven_context
    Raven.user_context(id: @current_user.try(:id)) # or anything else in session
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end

