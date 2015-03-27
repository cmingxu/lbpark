class Parks::BaseController < ApplicationController
  before_filter :current_client_required
end
