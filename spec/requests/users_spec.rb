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

      it 'should be logged in' do
        post users_path, params: user_params
        expect(logged_in?).to be_truthy
      end
    end

    context 'invalid values' do
      it 'error messages should be displayed' do
        visit signup_path
        fill_in 'Name', with: ''
        fill_in 'Email', with: 'user@invlid'
        fill_in 'Password', with: 'foo'
        fill_in 'Password confirmation', with: 'bar'
        click_button 'Create my account'

        expect(page).to have_selector 'div#error_explanation'
        expect(page).to have_selector 'div.field_with_errors'
      end
    end
  end

  describe 'get /users/{id}/edit' do
    let(:user) { FactoryBot.create(:user) }

    it 'タイトルがEdit user | Ruby on Rails Tutorial Sample Appであること' do
      log_in user
      get edit_user_path(user)
      expect(response.body).to include full_title('Edit user')
    end

    context '未ログインの場合' do
      it 'flashが空でないこと' do
        get edit_user_path(user)
        expect(flash).to_not be_empty
      end

      it '未ログインユーザはログインページにリダイレクトされること' do
        get edit_user_path(user)
        expect(response).to redirect_to login_path
      end

      it 'ログインすると編集ページにリダイレクトされること' do
        get edit_user_path(user)
        log_in user
        expect(response).to redirect_to edit_user_path(user)
      end
    end

    context '別のユーザの場合' do
      let(:other_user) { FactoryBot.create(:archer) }

      it 'flashが空であること' do
        log_in user
        get edit_user_path(other_user)
        expect(flash).to be_empty
      end

      it 'root_pathにリダイレクトされること' do
        log_in user
        get edit_user_path(other_user)
        expect(response).to redirect_to root_path
      end
    end

    it 'フレンドリーフォワーディング' do
      get edit_user_path(user)
      expect(session[:forwarding_url]).to eq edit_user_url(user)
      log_in user
      expect(session[:forwarding_url]).to be_nil
    end
  end

  describe 'PATCH /users' do
    let(:user) { FactoryBot.create(:user) }

    it 'タイトルがEdit user | Ruby on Rails Tutorial Sample Appであること' do
      get edit_user_path(user)
      expect(response.body).to include full_title('Edit user')
    end

    context '無効な値の場合' do
      before do
        log_in user
        patch user_path(user), params: { user: { name: '',
                                                 email: 'foo@invlid',
                                                 password: 'foo',
                                                 password_confirmation: 'bar' } }
      end

      it '更新できないこと' do
        user.reload
        expect(user.name).to_not eq ''
        expect(user.email).to_not eq ''
        expect(user.password).to_not eq 'foo'
        expect(user.password_confirmation).to_not eq 'bar'
      end

      it '更新アクション後にeditのページが表示されていること' do
        expect(response.body).to include full_title('Edit user')
      end

      it 'should be 4 errors' do
        expect(response.body).to include 'The form contains 4 errors.'
      end
    end

    context '有効な値の場合' do
      before do
        @name = 'Seiya Kawamoto'
        @email = 'seiya.kawamoto@example.com'
        patch user_path(user), params: { user: { name: @name,
                                                 email: @email,
                                                 password: '',
                                                 password_confirmation: ''} }
      end

      it 'shoulde be updated' do
        user.reload
        expect(user.name).to eq @name
        expect(user.email).to eq @email
      end

      it 'should be redirect user page' do
        expect(response).to redirect_to user
      end

      it 'should be display flash' do
        expect(flash).to be_any
      end
    end

    context '未ログインの場合' do
      it 'flashが空でないこと' do
        patch user_path(user), params: { user: { name: user.name,
                                                 email: user.email } }
        expect(flash).to_not be_empty
      end

      it '未ログインユーザはログインページにリダイレクトされること' do
        patch user_path(user), params: { user: { name: user.name,
                                                 email: user.email } }
        expect(response).to redirect_to login_path
      end
    end

    it 'admin属性は更新できないこと' do
      # userはこの後adminユーザになるので違うユーザにしておく
      log_in user = FactoryBot.create(:archer)
      expect(user).to_not be_admin

      patch user_path(user), params: { user: { password: 'password',
                                               password_confirmation: 'password',
                                               admin: true } }
      user.reload
      expect(user).to_not be_admin
    end
  end

  describe 'GET /users' do
    it 'ログインユーザでなければログインページにリダイレクトすること' do
      get users_path
      expect(response).to redirect_to login_path
    end

    describe 'pagination' do
      let(:user) { FactoryBot.create(:user) }

      before do
        30.times do
          FactoryBot.create(:continuous_users)
        end
        log_in user
        get users_path
      end

      it 'div.paginationが存在すること' do
        expect(response.body).to include '<div class="pagination">'
      end

      it 'ユーザごとのリンクが存在すること' do
        User.paginate(page: 1).each do |user|
          expect(response.body).to include "<a href=\"#{user_path(user)}\">"
        end
      end
    end
  end

  describe 'DELETE /users/{id}' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:other_user) { FactoryBot.create(:archer) }

    context 'adminユーザでログイン済みの場合' do
      it '削除できること' do
        log_in user
        expect {
          delete user_path(other_user)
        }.to change(User, :count).by -1
      end
    end

    context '未ログインの場合' do
      it '削除できないこと' do
        expect {
          delete user_path(user)
        }.to_not change(User, :count)
      end

      it 'ログインページにリダイレクトすること' do
        delete user_path(user)
        expect(response).to redirect_to login_path
      end
    end

    context 'adminユーザでない場合' do
      it '削除できないこと' do
        log_in other_user
        expect {
          delete user_path(user)
        }.to_not change(User, :count)
      end

      it 'rootにリダイレクトすること' do
        log_in other_user
        delete user_path(user)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#index' do
    let!(:admin) { FactoryBot.create(:user) }
    let!(:not_admin) { FactoryBot.create(:archer) }

    it 'adminユーザならdeleteリンクが表示されること' do
      log_in admin
      visit users_path

      expect(page).to have_link 'delete'
    end

    it 'adminユーザでなければdeleteリンクが表示されないこと' do
      log_in not_admin
      visit users_path

      expect(page).to_not have_link 'delete'
    end
  end
end
