require "rails_helper"

RSpec.describe("New Order Page") do
  describe "When I check out from my cart" do
    before(:each) do
      @mike = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create!(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create!(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"
    end

    it "I see all the information about my current cart" do
      visit "/cart"
      user_1 = User.create!(name: 'Grant',
                            address: '124 Grant Ave.',
                            city: 'Denver',
                            state: 'CO',
                            zip: 12_345,
                            email: 'grant@coolguy.com',
                            password: 'password',
                            role: 0)
      visit '/login'

      fill_in :email, with: user_1.email
      fill_in :password, with: user_1.password

      click_on 'Submit'

      expect(current_path).to eq("/profile")
      click_on "Cart"
      expect(current_path).to eq("/cart")

      expect(page).to have_link(@tire.name)
      expect(page).to have_link("#{@tire.merchant.name}")
      expect(page).to have_content("$#{@tire.price}")
      expect(page).to have_content("1")
      expect(page).to have_content("$100")

      expect(page).to have_link(@paper.name)
      expect(page).to have_link("#{@paper.merchant.name}")
      expect(page).to have_content("$#{@paper.price}")
      expect(page).to have_content("2")
      expect(page).to have_content("$40")

      expect(page).to have_link(@pencil.name)
      expect(page).to have_link("#{@pencil.merchant.name}")
      expect(page).to have_content("$#{@pencil.price}")
      expect(page).to have_content("1")
      expect(page).to have_content("$2")

      expect(page).to have_content("Total: $142")
    end

    it "I see a form where I can enter my shipping info" do
      visit "/cart"
      user_1 = User.create!(name: 'Grant',
                            address: '124 Grant Ave.',
                            city: 'Denver',
                            state: 'CO',
                            zip: 12_345,
                            email: 'grant@coolguy.com',
                            password: 'password',
                            role: 0)
      visit '/login'

      fill_in :email, with: user_1.email
      fill_in :password, with: user_1.password

      click_on 'Submit'

      expect(current_path).to eq("/profile")
      click_on "Cart"
      expect(current_path).to eq("/cart")

      click_on "Checkout"

      expect(page).to have_field(:name)
      expect(page).to have_field(:address)
      expect(page).to have_field(:city)
      expect(page).to have_field(:state)
      expect(page).to have_field(:zip)
      expect(page).to have_button("Create Order")
    end
  end

  it "When attempting to checkout from cart with items in cart I see info telling me I must register or log in with links" do
    mike = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    paper = mike.items.create!(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    pencil = mike.items.create!(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

    visit "/items/#{paper.id}"
    click_on "Add To Cart"
    visit "/items/#{paper.id}"
    click_on "Add To Cart"
    visit "/items/#{tire.id}"
    click_on "Add To Cart"
    visit "/items/#{pencil.id}"
    click_on "Add To Cart"

    visit "/cart"

    expect(page).to have_content("You must either register or login to checkout.")
    expect(current_path).to eq("/cart")
    expect(page).to have_link("register")
    expect(page).to have_link("log in")
  end

  it "When attempting to checkout from cart with items in cart I see info telling me I must register or log in with links" do
    mike = Merchant.create!(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    paper = mike.items.create!(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    pencil = mike.items.create!(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

    visit "/items/#{paper.id}"
    click_on "Add To Cart"
    visit "/items/#{paper.id}"
    click_on "Add To Cart"
    visit "/items/#{tire.id}"
    click_on "Add To Cart"
    visit "/items/#{pencil.id}"
    click_on "Add To Cart"

    visit "/cart"

    click_on "log in"
    user_1 = User.create!(name: 'Grant',
                          address: '124 Grant Ave.',
                          city: 'Denver',
                          state: 'CO',
                          zip: 12_345,
                          email: 'grant@coolguy.com',
                          password: 'password',
                          role: 0)
    visit '/login'

    fill_in :email, with: user_1.email
    fill_in :password, with: user_1.password

    click_on 'Submit'

    expect(current_path).to eq("/profile")
    click_on "Cart"
    expect(current_path).to eq("/cart")

    click_on "Checkout"

    expect(current_path).to eq("/orders/new")

    fill_in :name, with: user_1.name
    fill_in :address, with: user_1.address
    fill_in :city, with: user_1.city
    fill_in :state, with: user_1.state
    fill_in :zip, with: user_1.zip
    click_on "Create Order"

    expect(current_path).to eq("/profile/orders")
    expect(page).to have_content("Order successfully created!")
    expect(page).to have_content("Cart: 0")

  end
end
