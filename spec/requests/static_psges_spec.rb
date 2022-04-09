require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  let(:base_title) { 'Ruby on Rails Tutorial Sample App' }

  describe '#home' do
    it 'should get home' do
      get static_pages_home_path
      expect(response).to have_http_status :ok
    end

    it 'should include Ruby on Rails Tutorial Sample App' do
      get static_pages_home_path
      expect(response.body).to include "#{base_title}"
    end
  end

  describe '#help' do
    it 'should get help' do
      get static_pages_help_path
      expect(response).to have_http_status :ok
    end

    it 'should include Help | Ruby on Rails Tutorial Sample App' do
      get static_pages_help_path
      expect(response.body).to include "Help | #{base_title}"
    end
  end

  describe '#about' do
    it 'should get about' do
      get static_pages_about_path
      expect(response).to have_http_status :ok
    end

    it 'should include About | Ruby on Rails Tutorial Sample App' do
      get static_pages_about_path
      expect(response.body).to include "About | #{base_title}"
    end
  end
end