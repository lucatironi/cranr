# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Package, type: :model do
  describe 'db structure' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:version).of_type(:string) }
    it { is_expected.to have_db_column(:publication_date).of_type(:datetime) }
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:description).of_type(:text) }

    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

    it { is_expected.to have_db_index(:name) }
  end

  describe 'associations' do
    it { is_expected.to have_and_belong_to_many(:authors) }
    it { is_expected.to have_and_belong_to_many(:maintainers) }
  end

  describe 'scopes' do
    describe '.latest' do
      let!(:package_abc_ver_1) { Package.create(name: 'abc', version: '1', created_at: 7.days.ago) }
      let!(:package_abc_ver_2) { Package.create(name: 'abc', version: '2', created_at: 5.days.ago) }
      let!(:package_abc_ver_3) { Package.create(name: 'abc', version: '3', created_at: 2.days.ago) }

      let!(:package_xyz_ver_1) { Package.create(name: 'xyz', version: '1', created_at: 9.days.ago) }
      let!(:package_xyz_ver_2) { Package.create(name: 'xyz', version: '2', created_at: 7.days.ago) }
      let!(:package_xyz_ver_3) { Package.create(name: 'xyz', version: '3', created_at: 3.days.ago) }

      it { expect(Package.all).to match_array([
                                                package_abc_ver_1, package_abc_ver_2, package_abc_ver_3,
                                                package_xyz_ver_1, package_xyz_ver_2, package_xyz_ver_3
                                              ]) }

      it { expect(Package.latest).to match_array([package_abc_ver_3, package_xyz_ver_3]) }
    end
  end
end
