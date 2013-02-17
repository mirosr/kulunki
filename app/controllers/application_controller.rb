class ApplicationController < ActionController::Base
  protect_from_forgery

  def not_authenticated
    redirect_to signin_url, notice: flash.notice
  end
end
