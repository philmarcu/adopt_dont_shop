class AdminsController < ApplicationController
  def index
    @shelters = Shelter.order_by_reverse_name
  end
end
