# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PackagesController, type: :controller do
  let!(:package_1) { Package.create(valid_attributes) }
  let!(:package_2) { Package.create(valid_attributes) }

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
