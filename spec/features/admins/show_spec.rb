require 'rails_helper'


RSpec.describe 'admin show page' do
  it 'can approve applications' do
    shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

    bob_1 = Applicant.create(name: "Billy Bob", address: "Street address 6093", zip: 22323, city: "denver", state: "CO", description: "Something")

    pet_1 = shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    pet_2 = shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)
    pet_3 = shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)

    app_1 = ApplicantPet.create(applicant: bob_1, pet: pet_1, status: "In Progress")
    app_2 = ApplicantPet.create(applicant: bob_1, pet: pet_2, status: "In Progress")

    visit "/applications/#{bob_1.id}"

    fill_in 'description', with: 'Im Bob'
    click_on 'Submit Your Application'

    visit "/admin/applications/#{bob_1.id}"
    expect(current_path).to eq("/admin/applications/#{bob_1.id}")

    expect(page).to have_button('Approve Mr. Pirate')
    expect(page).to have_button('Approve Ann')
    expect(page).to_not have_button('Approve Clawdia')

    click_button 'Approve Mr. Pirate'
    expect(current_path).to eq("/admin/applications/#{bob_1.id}")

    expect(page).to_not have_button('Approve Mr. Pirate')
    expect(page).to have_button('Approve Ann')
    expect(page).to have_content('Mr. Pirate Approved!')
  end

  it 'can reject applications' do
    shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

    bob_1 = Applicant.create(name: "Billy Bob", address: "Street address 6093", zip: 22323, city: "denver", state: "CO", description: "Something")

    pet_1 = shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    pet_2 = shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)
    pet_3 = shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)

    app_1 = ApplicantPet.create(applicant: bob_1, pet: pet_1, status: "In Progress")
    app_2 = ApplicantPet.create(applicant: bob_1, pet: pet_2, status: "In Progress")

    visit "/applications/#{bob_1.id}"

    fill_in 'description', with: 'Im Bob'
    click_on 'Submit Your Application'

    visit "/admin/applications/#{bob_1.id}"
    expect(current_path).to eq("/admin/applications/#{bob_1.id}")

    expect(page).to have_button('Reject Mr. Pirate')
    expect(page).to have_button('Reject Ann')
    expect(page).to_not have_button('Reject Clawdia')

    click_button 'Reject Mr. Pirate'
    expect(current_path).to eq("/admin/applications/#{bob_1.id}")

    expect(page).to_not have_button('Approve Mr. Pirate')
    expect(page).to_not have_button('Reject Mr. Pirate')
    expect(page).to have_button('Approve Ann')
    expect(page).to have_button('Reject Ann')
    expect(page).to have_content('Mr. Pirate Rejected')
  end

  it 'can reject a pet on one applicants page without affecting another applicant with the same pet' do
    shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

    bob_1 = Applicant.create(name: "Billy Bob", address: "Street address 6093", zip: 22323, city: "denver", state: "CO", description: "Something")
    bob_2 = Applicant.create(name: "Harvey Birdman", address: "1723 Porter St", description: "Justice!", zip: 31123, city: "Denver", state: "CO", app_status: "In Progress")

    pet_1 = shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    pet_2 = shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)
    pet_3 = shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)

    app_1 = ApplicantPet.create(applicant: bob_1, pet: pet_1, status: "In Progress")
    app_2 = ApplicantPet.create(applicant: bob_1, pet: pet_2, status: "In Progress")
    app_1 = ApplicantPet.create(applicant: bob_2, pet: pet_1, status: "In Progress")
    app_2 = ApplicantPet.create(applicant: bob_2, pet: pet_3, status: "In Progress")

    visit "/applications/#{bob_1.id}"

    fill_in 'description', with: 'Im Bob'
    click_on 'Submit Your Application'

    visit "/applications/#{bob_2.id}"

    fill_in 'description', with: 'Im Bob'
    click_on 'Submit Your Application'

    visit "/admin/applications/#{bob_1.id}"
    expect(current_path).to eq("/admin/applications/#{bob_1.id}")

    click_button 'Reject Mr. Pirate'
    expect(current_path).to eq("/admin/applications/#{bob_1.id}")

    expect(page).to_not have_button('Approve Mr. Pirate')
    expect(page).to_not have_button('Reject Mr. Pirate')
    expect(page).to have_button('Approve Ann')
    expect(page).to have_content('Mr. Pirate Rejected')

    visit "/admin/applications/#{bob_2.id}"
    expect(current_path).to eq("/admin/applications/#{bob_2.id}")

    expect(page).to have_button('Approve Mr. Pirate')
    expect(page).to have_button('Reject Mr. Pirate')
    expect(page).to have_button('Approve Clawdia')
  end

  it 'can approve a pet on one applicants page without affecting another applicant with the same pet' do
    shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

    bob_1 = Applicant.create(name: "Billy Bob", address: "Street address 6093", zip: 22323, city: "denver", state: "CO", description: "Something")
    bob_2 = Applicant.create(name: "Harvey Birdman", address: "1723 Porter St", description: "Justice!", zip: 31123, city: "Denver", state: "CO", app_status: "In Progress")

    pet_1 = shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    pet_2 = shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)
    pet_3 = shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)

    app_1 = ApplicantPet.create(applicant: bob_1, pet: pet_1, status: "In Progress")
    app_2 = ApplicantPet.create(applicant: bob_1, pet: pet_2, status: "In Progress")
    app_1 = ApplicantPet.create(applicant: bob_2, pet: pet_1, status: "In Progress")
    app_2 = ApplicantPet.create(applicant: bob_2, pet: pet_3, status: "In Progress")

    visit "/applications/#{bob_1.id}"

    fill_in 'description', with: 'Im Bob'
    click_on 'Submit Your Application'

    visit "/applications/#{bob_2.id}"

    fill_in 'description', with: 'Im Bob'
    click_on 'Submit Your Application'

    visit "/admin/applications/#{bob_1.id}"
    expect(current_path).to eq("/admin/applications/#{bob_1.id}")

    click_button 'Approve Mr. Pirate'
    expect(current_path).to eq("/admin/applications/#{bob_1.id}")

    expect(page).to_not have_button('Approve Mr. Pirate')
    expect(page).to_not have_button('Reject Mr. Pirate')
    expect(page).to have_button('Approve Ann')
    expect(page).to have_content('Mr. Pirate Approved')

    visit "/admin/applications/#{bob_2.id}"
    expect(current_path).to eq("/admin/applications/#{bob_2.id}")

    expect(page).to have_button('Approve Mr. Pirate')
    expect(page).to have_button('Reject Mr. Pirate')
    expect(page).to have_button('Approve Clawdia')
  end
end
