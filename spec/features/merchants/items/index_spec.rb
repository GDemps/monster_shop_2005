require 'rails_helper'

RSpec.describe "Merchant Items Index Page" do
  describe "When I visit the merchant items page" do
    before(:each) do
      @merchant_1 = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @merchant_1.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @chain = @merchant_1.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @shifter = @merchant_1.items.create(name: "Shimano Shifters", description: "It'll always shift!", activation_status: 'Deactivated', price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)
      @user_1 = @merchant_1.users.create!(name: 'Grant', address: '124 Grant Ave.', city: 'Denver', state: 'CO', zip: 12345, email: 'grant@coolguy.com', password: 'password', role: 1)

      visit '/login'
      fill_in :email, with: @user_1.email
      fill_in :password, with: @user_1.password
      click_on 'Submit'
    end

    it 'I can see all of the merchant items' do
      visit "merchant/items"

      within "#item-#{@tire.id}" do
        expect(page).to have_content(@tire.name)
        expect(page).to have_content("Description: #{@tire.description}")
        expect(page).to have_content(@tire.price)
        expect(page).to have_css("img[src*='#{@tire.image}']")
        expect(page).to have_content("Status: Active")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
      end

      within "#item-#{@chain.id}" do
        expect(page).to have_content(@chain.name)
        expect(page).to have_content("Description: #{@chain.description}")
        expect(page).to have_content(@chain.price)
        expect(page).to have_css("img[src*='#{@chain.image}']")
        expect(page).to have_content("Status: Active")
        expect(page).to have_content("Inventory: #{@chain.inventory}")
      end
    end

    it 'I can see a link to add a new item' do
      visit "merchant/items"

      expect(page).to have_link("Add Item")
      click_link 'Add Item'
      expect(current_path).to eq("/merchant/items/new")
    end

    it 'I can see a link to edit an item' do
      visit "merchant/items"

      within "#item-#{@tire.id}" do
        expect(page).to have_link("Edit Item")
      end

      within "#item-#{@chain.id}" do
        expect(page).to have_link("Edit Item")
        click_link('Edit Item')

        expect(current_path).to eq("/merchant/items/#{@chain.id}/edit")
      end
    end
  end
end
