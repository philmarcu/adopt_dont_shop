require 'rails_helper'


RSpec.describe 'New Applicant form page' do
  it 'links to a new page app form' do
    shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

    pet_1 = shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    pet_2 = shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    pet_3 = shelter_1.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)

    bob_1 = Applicant.create(name: "Billy Bob", address: "Street address 6093", zip: 22323, city: "Denver", state: "CO")
    bob_2 = Applicant.create(name: "Freiza", address: "Acne Lane 80422", zip: 80029, city: "Bouler", state: "CO")
    bob_3 = Applicant.create(name: "James Maddy", address: "Street address 6093", zip: 71123, city: "Lander", state: "WY")

    visit '/pets'

    click_link("Start an Application", :match => :first)

    expect(page).to have_content("Pet Adoption Form")
    expect(find('form')).to have_content('Name')
    expect(find('form')).to have_content('Address')
    expect(find('form')).to have_content('Zip')
    expect(find('form')).to have_content('City')
    expect(find('form')).to have_content('State')
  end

  describe 'applicant create' do
    context 'given valid data' do
      it 'creates a new applicant and returns to show' do        
        visit '/applications/new'
        
        fill_in 'Name', with: 'Billy Bob'
        fill_in 'Address', with: 'Street address 6093'
        fill_in 'Zip', with: 22323
        fill_in 'City', with: 'Denver'
        fill_in 'State', with: 'CO'
                
        click_button 'Save'

        expect(page).to have_content("Billy Bob")
        expect(page).to have_content("Street address 6093")
        expect(page).to have_content("In Progress")
        expect(page).to have_content(22323)
      end
    end

    context "given invalid data" do
      it 're-renders the edit form' do
        visit '/applications/new'

        fill_in 'Name', with: ''
        fill_in 'Address', with: ''
        fill_in 'Zip', with: 22323
        fill_in 'City', with: 'Denver'
        fill_in 'State', with: 'CO'

        click_button 'Save'
  
        expect(page).to have_content("Error: Name can't be blank, Address can't be blank")
        expect(page).to have_current_path("/applications/new")
      end
    end
  end
end