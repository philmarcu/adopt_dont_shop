require 'rails_helper'

RSpec.describe 'applicant' do
  it 'displays a link to all pets' do
    visit '/'
    expect(page).to have_content("Adopt, don't shop!")
    expect(page).to have_link("Pets")
    click_link("Pets")
    expect(page).to have_current_path('/pets')
  end

  it 'displays a link to all shelters' do
    visit '/'

    expect(page).to have_link("Shelters")
    click_link("Shelters")
    expect(page).to have_current_path('/shelters')
    expect(page).to have_link("Shelters")
    expect(page).to have_link("Pets")
    expect(page).to have_link("Veterinarians")
    expect(page).to have_link("Veterinary Offices")
  end

  it 'displays a link to all veterinary offices' do
    visit '/'

    expect(page).to have_link("Veterinary Offices")
    click_link("Veterinary Offices")
    expect(page).to have_current_path('/veterinary_offices')
    expect(page).to have_link("Shelters")
    expect(page).to have_link("Pets")
    expect(page).to have_link("Veterinarians")
    expect(page).to have_link("Veterinary Offices")
  end

  it 'displays a link to all veterinarians' do
    visit '/'

    expect(page).to have_link("Veterinarians")
    click_link("Veterinarians")
    expect(page).to have_current_path('/veterinarians')
    expect(page).to have_link("Shelters")
    expect(page).to have_link("Pets")
    expect(page).to have_link("Veterinarians")
    expect(page).to have_link("Veterinary Offices")
  end

  it 'displays a link to start an application' do
    visit '/'
    expect(page).to have_link("Start an Application")
    click_link("Start an Application")
    expect(find('form')).to have_content('Name')
    expect(find('form')).to have_content('Address')
    expect(find('form')).to have_content('Zip')
    expect(find('form')).to have_content('City')
    expect(find('form')).to have_content('State')
  end
end
