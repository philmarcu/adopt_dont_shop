require 'rails_helper'


RSpec.describe 'New Applicant form page' do
  describe 'new applicant page' do
    it 'links to a new page app form' do
      shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

      pet_1 = shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
      pet_2 = shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
      pet_3 = shelter_1.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)

      bob_1 = Applicant.create(name: "Billy Bob", address: "Street address 6093", description: "I'm bob", status: "In Progress", zip: 22323, city: "Denver", state: "CO")
      bob_2 = Applicant.create(name: "Freiza", address: "Acne Lane 80422", description: "I'm freiza 2", status: "In Progress", zip: 80029, city: "Bouler", state: "CO")
      bob_3 = Applicant.create(name: "James Maddy", address: "Street address 6093", description: "I'm in Wyoming", status: "Progress", zip: 71123, city: "Lander", state: "WY")

      visit '/pets'

      click_link("Start an Application", :match => :first)
      
      expect(page).to have_content("Pet Adoption Form")
      expect(find('form')).to have_content('Name')
      expect(find('form')).to have_content('Address')
      expect(find('form')).to have_content('Zip')
      expect(find('form')).to have_content('City')
      expect(find('form')).to have_content('State')
      expect(find('form')).to have_content('Description')
    end
  end

  describe 'applicant create' do
    context 'valid data' do
      it 'creates a new applicant and returns to show' do        
        visit '/applications/new'
        
        fill_in 'Name', with: 'Billy Bob'
        fill_in 'Address', with: 'Street address 6093'
        fill_in 'Zip', with: 22323
        fill_in 'City', with: 'Denver'
        fill_in 'State', with: 'CO'
        fill_in 'Description', with: "I'm bob"
        select 'In Progress', from: 'status'
        
        click_button 'Save'

        save_and_open_page

        expect(page).to have_content("Billy Bob")
        expect(page).to have_content("Street address 6093")
        expect(page).to have_content("I'm bob")
        expect(page).to have_content("In Progress")
        expect(page).to have_content(22323)
      end
    end
  end
end





# Starting an Application

# As a visitor
# When I visit the pet index page
# Then I see a link to "Start an Application"
# When I click this link
# Then I am taken to the new application page where I see a form
# When I fill in this form with my:
#   - Name
#   - Street Address
#   - City
#   - State
#   - Zip Code
# And I click submit
# Then I am taken to the new application's show page
# And I see my Name, address information, and description of why I would make a good home
# And I see an indicator that this application is "In Progress"



# -------------------------------
# describe 'the shelter new' do
#   it 'renders the new form' do
#     visit '/shelters/new'

#     expect(page).to have_content('New Shelter')
#     expect(find('form')).to have_content('Name')
#     expect(find('form')).to have_content('City')
#     expect(find('form')).to have_content('Rank')
#     expect(find('form')).to have_content('Foster program')
#   end
# end

# describe 'the shelter create' do
#   context 'given valid data' do
#     it 'creates the shelter' do
#       visit '/shelters/new'

#       fill_in 'Name', with: 'Houston Shelter'
#       fill_in 'City', with: 'Houston'
#       check 'Foster program'
#       fill_in 'Rank', with: 7
#       click_button 'Save'

#       expect(page).to have_current_path('/shelters')
#       expect(page).to have_content('Houston Shelter')
#     end
#   end

#   context 'given invalid data' do
#     it 're-renders the new form' do
#       visit '/shelters/new'
#       click_button 'Save'

#       fill_in 'City', with: 'Houston'

#       expect(page).to have_content("Error: Name can't be blank, Rank can't be blank, Rank is not a number")
#       expect(page).to have_current_path('/shelters/new')
#     end
#   end
# end
# end