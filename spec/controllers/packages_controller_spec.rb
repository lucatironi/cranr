# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PackagesController, type: :controller do
  let(:valid_attributes_1) {
    {
      name: 'abc',
      version: '1.2.3',
      publication_date: 2.months.ago,
      title: 'Lorem ipsum',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, ' \
        'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut ' \
        'enim ad minim veniam, quis nostrud exercitation'
    }
  }

  let(:valid_attributes_2) {
    {
      name: 'xyz',
      version: '2.3',
      publication_date: 3.months.ago,
      title: 'Lorem ipsum',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, ' \
        'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut ' \
        'enim ad minim veniam, quis nostrud exercitation'
    }
  }

  let!(:package_1) { Package.create(valid_attributes_1) }
  let!(:package_2) { Package.create(valid_attributes_2) }

  describe 'GET #index' do
    it 'assigns all packages as @packages' do
      get :index
      expect(assigns(:packages)).to match_array([package_1, package_2])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested package as @package' do
      get :show, params: { id: package_1.id }
      expect(assigns(:package)).to eq(package_1)
    end
  end
end
