class ApplicantPetsController < ApplicationController

  def add
    @applicant = Applicant.find(params[:id])
    @pet = Pet.find(params[:chosen_pet])
    app_1 = ApplicantPet.create(applicant: @applicant, pet: @pet, status: "In Progress")
    redirect_to "/applications/#{@applicant.id}"
  end

end
