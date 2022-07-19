require 'rails_helper'
RSpec.describe ApplicantPet do
  describe "relationships" do
    it {should belong_to(:applicant)}
    it {should belong_to(:pet)}
  end

  describe "validations" do
    it { should validate_presence_of(:status)}
  end
end
