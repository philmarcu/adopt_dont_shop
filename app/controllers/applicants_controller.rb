class ApplicantsController < ApplicationController

  def new

  end

  def show
    @applicant = Applicant.find(params[:applicant_id])
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
