require 'rails_helper'

RSpec.describe 'Logging in' do
  describe 'As a default user' do
    it 'can login with valid credentials' do
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

      expect(current_path).to eq('/profile')
      expect(page).to have_content('Logged In!')
    end
  end

  describe 'As a merchant user' do
    it 'can login with valid credentials' do
      user_1 = User.create!(name: 'Grant',
                            address: '124 Grant Ave.',
                            city: 'Denver',
                            state: 'CO',
                            zip: 12_345,
                            email: 'grant@coolguy.com',
                            password: 'password',
                            role: 1)
      visit '/login'

      fill_in :email, with: user_1.email
      fill_in :password, with: user_1.password

      click_on 'Submit'

      expect(current_path).to eq('/merchant')
      expect(page).to have_content('Logged In!')
    end
  end

  describe 'As a admin user' do
    it 'can login with valid credentials' do
      user_1 = User.create!(name: 'Grant',
                            address: '124 Grant Ave.',
                            city: 'Denver',
                            state: 'CO',
                            zip: 12_345,
                            email: 'grant@coolguy.com',
                            password: 'password',
                            role: 2)
      visit '/login'

      fill_in :email, with: user_1.email
      fill_in :password, with: user_1.password

      click_on 'Submit'

      expect(current_path).to eq('/admin')
      expect(page).to have_content('Logged In!')
    end
  end

  describe 'User cannot login because of incorrect credentials.' do
    it "should display a flash message 'Credentials are incorrect'" do
      user_1 = User.create!(name: 'Grant',
                            address: '124 Grant Ave.',
                            city: 'Denver',
                            state: 'CO',
                            zip: 12_345,
                            email: 'grant@coolguy.com',
                            password: 'password',
                            role: 2)
      visit '/login'

      fill_in :email, with: user_1.email
      fill_in :password, with: 'fake123'

      click_on 'Submit'

      expect(page).to have_content('Credentials are incorrect')
    end
  end

  describe 'Users who are logged in already are redirected' do
    describe 'As a default user' do
      it "redirects user to profile page" do
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

        visit '/login'

        expect(page).to_not have_link("Log In")
        expect(page).to have_content("You are already logged in")
        expect(current_path).to eq('/profile')
      end
    end
    describe 'As a merchant user' do
      it "redirects user to merchant dashboard page" do
        user_1 = User.create!(name: 'Grant',
                              address: '124 Grant Ave.',
                              city: 'Denver',
                              state: 'CO',
                              zip: 12_345,
                              email: 'grant@coolguy.com',
                              password: 'password',
                              role: 1)

        visit '/login'

        fill_in :email, with: user_1.email
        fill_in :password, with: user_1.password

        click_on 'Submit'

        visit '/login'

        expect(page).to_not have_link("Log In")
        expect(page).to have_content("You are already logged in")
        expect(current_path).to eq('/merchant')
      end
    end
    describe 'As an admin user' do
      it "redirects user to admin dashboard page" do
        user_1 = User.create!(name: 'Grant',
                              address: '124 Grant Ave.',
                              city: 'Denver',
                              state: 'CO',
                              zip: 12_345,
                              email: 'grant@coolguy.com',
                              password: 'password',
                              role: 2)

        visit '/login'

        fill_in :email, with: user_1.email
        fill_in :password, with: user_1.password

        click_on 'Submit'

        visit '/login'

        expect(page).to_not have_link("Log In")
        expect(page).to have_content("You are already logged in")
        expect(current_path).to eq('/admin')
      end
    end
  end
end
