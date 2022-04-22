require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get signup_path
      expect(response).to have_http_status(:success)
    end

    it 'Sign up | Ruby on Rails Tutorial Sample Appが含まれること' do
      get signup_path
      expect(response.body).to include full_title('Sign up')
    end
  end

  describe 'POST /users #create' do
    it 'invalid signup information' do
      get signup_path
      expect {
        post signup_path, params: { user: { name: '',
                                            email: 'user@invalid',
                                            password: 'foo',
                                            password_confirmation: 'bar' } }
        }.to_not change(User, :count)
    end

    context 'case valid values' do
      let(:user_params) { { user: { name: 'Example User',
                                    email: 'user@example.com',
                                    password: 'password',
                                    password_confirmation: 'password' } } }

      it 'should be registered' do
        expect {
          post users_path, params: user_params
        }.to change(User, :count).by 1
      end

      it 'should be redirected to users/show' do
        post users_path, params: user_params
        user = User.last
        expect(response).to redirect_to user
      end

      it 'flash must be displayed.' do
        post users_path, params: user_params
        expect(flash).to be_any
      end
    end

    context 'invalid values' do
      it 'error messages should be displayed' do
        visit signup_path
        fill_in 'Name', with: ''
        fill_in 'Email', with: 'user@invlid'
        fill_in 'Password', with: 'foo'
        fill_in 'Confirmation', with: 'bar'
        click_button 'Create my account'

        expect(page).to have_selector 'div#error_explanation'
        expect(page).to have_selector 'div.field_with_errors'
      end
    end
  end
end
