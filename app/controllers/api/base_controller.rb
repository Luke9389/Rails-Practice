class Api::BaseController < ApplicationController
  # Skip CSRF token verification for API requests
  skip_before_action :verify_authenticity_token

  # API-specific authentication (we'll keep it simple for now)
  before_action :authenticate_api_user!

  private

  def authenticate_api_user!
    # For now, use session-based auth (same as web)
    # In production, you'd use token authentication
    unless Current.user
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end