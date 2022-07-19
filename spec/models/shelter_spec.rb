require 'rails_helper'

RSpec.describe Shelter, type: :model do
  describe 'relationships' do
    it { should have_many(:pets) }
    it {should have_many(:applicant_pets).through(:pets)}

  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:rank) }
    it { should validate_numericality_of(:rank) }
  end

  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @pet_4 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)

    @bob_1 = Applicant.create(name: "Billy Bob", address: "Street address 6093", description: "I'm bob", zip: 22323, city: "Denver", state: "CO", app_status: "Pending")
    @bob_2 = Applicant.create(name: "Freiza", address: "Acne Lane 80422", description: "I'm freiza 2", zip: 80029, city: "Namek", state: "NH", app_status: "Pending")
    @bob_3 = Applicant.create(name: "James Maddy", address: "3072 Wallaby Way", description: "Pets please", zip: 31123, city: "Sydney", state: "AL", app_status: "Pending")

    @app_1 = ApplicantPet.create(applicant: @bob_1, pet: @pet_1, status: "In Progress")
    @app_4 = ApplicantPet.create(applicant: @bob_3, pet: @pet_3, status: "In Progress")
  end

  describe 'class methods' do
    describe '#search' do
      it 'returns partial matches' do
        expect(Shelter.search("Fancy")).to eq([@shelter_3])
      end
    end

    describe '#order_by_recently_created' do
      it 'returns shelters with the most recently created first' do
        expect(Shelter.order_by_recently_created).to eq([@shelter_3, @shelter_2, @shelter_1])
      end
    end

    describe '#order_by_number_of_pets' do
      it 'orders the shelters by number of pets they have, descending' do
        expect(Shelter.order_by_number_of_pets).to eq([@shelter_1, @shelter_3, @shelter_2])
      end
    end

    describe '#order_by_reverse_name' do
      it 'orders the shelters by name in reverse' do
        expect(Shelter.order_by_reverse_name).to eq([@shelter_2, @shelter_3, @shelter_1])
      end
    end

    describe '#pending_apps' do
      it 'returns shelters with pending apps' do
        expect(Shelter.pending_apps).to eq([@shelter_1, @shelter_3])
      end
    end
  end

  describe 'instance methods' do
    describe '.adoptable_pets' do
      it 'only returns pets that are adoptable' do
        expect(@shelter_1.adoptable_pets).to eq([@pet_2, @pet_4])
      end
    end

    describe '.alphabetical_pets' do
      it 'returns pets associated with the given shelter in alphabetical name order' do
        expect(@shelter_1.alphabetical_pets).to eq([@pet_4, @pet_2])
      end
    end

    describe '.shelter_pets_filtered_by_age' do
      it 'filters the shelter pets based on given params' do
        expect(@shelter_1.shelter_pets_filtered_by_age(5)).to eq([@pet_4])
      end
    end

    describe '.pet_count' do
      it 'returns the number of pets at the given shelter' do
        expect(@shelter_1.pet_count).to eq(3)
      end
    end

    describe '.pending_shelter_names' do
      it 'returns shelter names that have pending applications' do

      end
    end
  end
end
