class SessionsController < ApplicationController
  layout 'auth', only: :new

  def new
  end
end
