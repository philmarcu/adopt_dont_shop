class AdminsController < ApplicationController

 def show
   @applicant = Applicant.find(params[:id])
 end

 def sendapprove
   @app_1 = ApplicantPet.find(params[:id])
   @app_1.update(status: "Approved")
   @app_1.save
   redirect_to "/admin/applications/#{@app_1.applicant_id}"
 end

 def sendreject
   @app_1 = ApplicantPet.find(params[:id])
   @app_1.update(status: "Rejected")
   @app_1.save
   redirect_to "/admin/applications/#{@app_1.applicant_id}"
 end

 def index
  @shelters = Shelter.order_by_reverse_name
  @shelters_pending_apps = Shelter.pending_apps
 end
end
