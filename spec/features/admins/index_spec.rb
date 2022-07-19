require 'rails_helper'

RSpec.describe 'admin shelter index page' do
  context 'reverse order shelter names alphabetical' do
    it 'displays all shelter names in reverse' do
      shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
      shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

      visit "/admin/shelters"

      within "#shelter-#{shelter_2.id}" do
        expect(page).to have_content("RGV animal shelter")
        expect(page).to_not have_content("Aurora shelter")
        
      end 
      
      within "#shelter-#{shelter_3.id}" do
        expect(page).to have_content("Fancy pets of Colorado")
        expect(page).to_not have_content("RGV animal shelter")
      end
      
      within "#shelter-#{shelter_1.id}" do
        expect(page).to have_content("Aurora shelter")
        expect(page).to_not have_content("Fancy pets of Colorado")
      end
    end
  end

  describe 'specific shelter name list' do
    context 'shelters with pending applications' do
      it 'displays the name of every shelter that has a pending app' do
        shelter_1 = Shelter.create(name: 'New Age shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
        shelter_2 = Shelter.create(name: 'Griffy Pets shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
        shelter_3 = Shelter.create(name: 'Super Pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

        bob_1 = Applicant.create(name: "Billy Bob", address: "Street address 6093", zip: 22323, city: "denver", state: "CO", app_status: "Pending")
        bob_2 = Applicant.create(name: "Harvey Birdman", address: "1723 Porter St", description: "Justice!", zip: 31123, city: "Denver", state: "CO", app_status: "Pending")
        bob_3 = Applicant.create(name: "James Maddy", address: "3072 Wallaby Way", description: "Pets please", zip: 31123, city: "Sydney", state: "AL", app_status: "In Progress")

        pet_1 = shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
        pet_2 = shelter_2.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
        pet_3 = shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)
        pet_4 = shelter_3.pets.create(name: 'Bailey', breed: 'labrador', age: 2, adoptable: true)

    
        app_1 = ApplicantPet.create(applicant: bob_1, pet: pet_1, status: "Pending")
        app_2 = ApplicantPet.create(applicant: bob_1, pet: pet_3, status: "Pending")
        app_3 = ApplicantPet.create(applicant: bob_2, pet: pet_2, status: "Pending")
        app_4 = ApplicantPet.create(applicant: bob_2, pet: pet_4, status: "Pending")

        visit "/admin/shelters"

        expect(page).to have_content("Shelters with Pending Applications")

        within "#pending-#{shelter_1.id}" do
          expect(page).to have_content('New Age shelter')
          expect(page).to_not have_content('Griffy Pets shelter')
          expect(page).to_not have_content('Super Pets of Colorado')
        end

        within "#pending-#{shelter_2.id}" do
          expect(page).to have_content('Griffy Pets shelter')
          expect(page).to_not have_content('New Age shelter')
          expect(page).to_not have_content('Super Pets of Colorado')
        end

        within "#pending-#{shelter_3.id}" do
          expect(page).to have_content('Super Pets of Colorado')
          expect(page).to_not have_content('Griffy Pets shelter')
          expect(page).to_not have_content('New Age shelter')
        end
      end
    end
  end
end