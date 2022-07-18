require 'rails_helper'

RSpec.describe 'applicant show page' do
  it 'user story 1' do
    shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    bob_1 = Applicant.create(name: "Billy Bob", address: "Street address 6093", zip: 22323, city: "denver", state: "CO")

    pet_1 = shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    pet_2 = shelter_2.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    pet_3 = shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    pet_4 = shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)

    app_1 = ApplicantPet.create(applicant: bob_1, pet: pet_1, status: "In Progress")
    app_2 = ApplicantPet.create(applicant: bob_1, pet: pet_4, status: "In Progress")


    visit "/applications/#{bob_1.id}"

    expect(page).to have_content("Billy Bob")
    expect(page).to have_content("Street address 6093")
    expect(page).to have_content(22323)

    expect(page).to have_link('Ann')
    expect(page).to have_link('Mr. Pirate')

    click_link('Mr. Pirate')

    expect(current_path).to eq("/pets/#{pet_1.id}")
  end

  it 'user story 4' do
    shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
    bob_1 = Applicant.create(name: "Billy Bob", address: "Street address 6093", zip: 22323, city: "denver", state: "CO")
    pet_1 = shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    pet_2 = shelter_2.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    pet_3 = shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    pet_4 = shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)
    app_1 = ApplicantPet.create(applicant: bob_1, pet: pet_1, status: "In Progress")
    app_2 = ApplicantPet.create(applicant: bob_1, pet: pet_4, status: "In Progress")

    visit "/applications/#{bob_1.id}"
    expect(current_path).to eq("/applications/#{bob_1.id}")

    expect(page).to have_content("In Progress")
    expect(page).to_not have_content('Clawdia')
    expect(page).to have_content("Add a Pet to this Application")

    fill_in 'pet_name', with: 'Clawdia'
    click_on 'Submit'

    expect(current_path).to eq("/applications/#{bob_1.id}")
    expect(page).to have_content('Clawdia')
  end

  it 'user story 5' do
    shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
    bob_1 = Applicant.create(name: "Billy Bob", address: "Street address 6093", description: "I'm bob", zip: 22323, city: "denver", state: "CO")
    pet_1 = shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    pet_2 = shelter_2.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    pet_3 = shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    pet_4 = shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)
    app_1 = ApplicantPet.create(applicant: bob_1, pet: pet_1, status: "In Progress")
    app_2 = ApplicantPet.create(applicant: bob_1, pet: pet_4, status: "In Progress")

    visit "/applications/#{bob_1.id}"
    expect(current_path).to eq("/applications/#{bob_1.id}")

    fill_in 'pet_name', with: 'Clawdia'
    click_on 'Submit'
    expect(current_path).to eq("/applications/#{bob_1.id}")

    click_on 'Adopt Clawdia'

    expect(page).to have_link('Clawdia')
  end

  describe 'user story 6 + 8' do
    context 'submits the application' do
      it 'goes to a submit application section in show page' do
        shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

        bob_1 = Applicant.create(name: "Billy Bob", address: "Street address 6093", zip: 22323, city: "denver", state: "CO", description: "Something")

        pet_1 = shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
        pet_2 = shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)

        app_1 = ApplicantPet.create(applicant: bob_1, pet: pet_1, status: "In Progress")
        app_2 = ApplicantPet.create(applicant: bob_1, pet: pet_2, status: "In Progress")

        visit "/applications/#{bob_1.id}"

        fill_in 'description', with: 'Im Bob'
        click_on 'Submit Your Application'

        expect(page).to have_content('Mr. Pirate')
        expect(page).to have_content('Ann')
        expect(page).to have_content("Pending")
      end

      it 'does not show submit section if no pet is added' do
        shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

        bob_1 = Applicant.create(name: "Billy Bob", address: "Street address 6093", zip: 22323, city: "denver", state: "CO", description: "Something")

        pet_1 = shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
        pet_2 = shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)

        visit "/applications/#{bob_1.id}"

        expect(page).to_not have_content('Submit Your Application')
      end

      it 'matches partial information for name searches User story 8' do
        shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
        shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
        shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
        bob_1 = Applicant.create(name: "Billy Bob", address: "Street address 6093", description: "I'm bob", zip: 22323, city: "denver", state: "CO")
        pet_1 = shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
        pet_2 = shelter_2.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
        pet_3 = shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
        pet_4 = shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)
        app_1 = ApplicantPet.create(applicant: bob_1, pet: pet_1, status: "In Progress")
        app_2 = ApplicantPet.create(applicant: bob_1, pet: pet_4, status: "In Progress")

        visit "/applications/#{bob_1.id}"
        expect(current_path).to eq("/applications/#{bob_1.id}")

        expect(page).to_not have_content('Clawdia')
        expect(page).to_not have_content('Lucille Bald')

        fill_in 'pet_name', with: 'Claw'
        click_on 'Submit'

        expect(current_path).to eq("/applications/#{bob_1.id}")
        expect(page).to have_content('Clawdia')

        fill_in 'pet_name', with: 'Lucille'
        click_on 'Submit'

        expect(current_path).to eq("/applications/#{bob_1.id}")
        expect(page).to have_content('Lucille Bald')
      end

      it 'can case insensitive search for pet name' do
        shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

        bob_1 = Applicant.create(name: "Billy Bob", address: "Street address 6093", zip: 22323, city: "denver", state: "CO", description: "Something")

        pet_1 = shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
        pet_2 = shelter_1.pets.create(name: 'Cleopatra', breed: 'ragdoll', age: 5, adoptable: true)

        visit "/applications/#{bob_1.id}"

        expect(page).to_not have_content('Mr. Pirate')
        expect(page).to_not have_content('Ann')

        fill_in 'pet_name', with: 'mR. pIrAtE'
        click_on 'Submit'

        expect(current_path).to eq("/applications/#{bob_1.id}")
        expect(page).to have_content('Mr. Pirate')

        fill_in 'pet_name', with: 'cLeoPa'
        click_on 'Submit'

        expect(current_path).to eq("/applications/#{bob_1.id}")
        expect(page).to have_content('Cleopatra')
      end

      it 'does not show submit form if applicant is not in progress' do
        shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

        bob_1 = Applicant.create(name: "Billy Bob", address: "Street address 6093", zip: 22323, city: "denver", state: "CO", description: "Something", app_status: "Pending")

        pet_1 = shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
        pet_2 = shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)

        app_1 = ApplicantPet.create(applicant: bob_1, pet: pet_1, status: "In Progress")
        app_2 = ApplicantPet.create(applicant: bob_1, pet: pet_2, status: "In Progress")

        visit "/applications/#{bob_1.id}"
      
        expect(page).to have_content("Pending")
        expect(page).to_not have_content('Submit Your Application')
      end
    end
  end
end
