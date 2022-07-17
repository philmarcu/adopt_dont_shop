class ApplicantPet < ApplicationRecord
  belongs_to :pet
  belongs_to :applicant

  validates :status, presence: true
end
