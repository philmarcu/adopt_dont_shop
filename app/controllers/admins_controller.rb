class AdminsController < ApplicationController
  def index
    @shelters = Shelter.order_by_reverse_name
    @shelters_pending_apps = Shelter.pending_apps
  end
end
