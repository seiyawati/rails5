require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe '#new' do
    context 'login with valid information' do
      let(:user) { FactoryBot.create(:user) }

      it 'should be display the page for logged-in users' do
        visit login_path

        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_button 'Log in'

        expect(page).to_not have_selector "a[href=\"#{login_path}\"]"
        expect(page).to have_selector "a[href=\"#{logout_path}\"]"
        expect(page).to have_selector "a[href=\"#{user_path(user)}\"]"
      end
    end

    context 'login with invalid information' do
      it 'flash message is displayed' do
        visit login_path

        fill_in 'Email', with: ''
        fill_in 'Password', with: ''
        click_button 'Log in'

        expect(page).to have_selector 'div.alert.alert-danger'

        visit root_path
        expect(page).to_not have_selector 'div.alert.alert-danger'
      end
    end
  end
end