class ApplicantsController < ApplicationController

  def new

  end

  def show
    @applicant = Applicant.find(params[:id])
      require "pry"; binding.pry
    if params[:pet_name]
      @new_pets = Pet.pet_search(params[:pet_name])
    end
  end

  def create
    @applicant = Applicant.new(applicant_params)

    if @applicant.save
      redirect_to "/applications/#{@applicant.id}"
    else
      redirect_to '/applications/new'
      flash[:alert] = "Error: #{error_message(@applicant.errors)}"
    end
  end

  private
  def applicant_params
    params.permit(:name, :address, :description, :zip, :city, :state, :status)
  end
end
