class ApplicantsController < ApplicationController

  def new

  end

  def show
    @applicant = Applicant.find(params[:id])
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

  def stat_update
    @applicant = Applicant.find(params[:id])
    @applicant.update!(app_status: params[:app_status], description: params[:description])
    redirect_to "/applications/#{@applicant.id}"
  end

  private
  def applicant_params
    params.permit(:name, :address, :zip, :city, :state)
  end
end
