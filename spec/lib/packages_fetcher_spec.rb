require 'spec_helper'
require 'packages_fetcher'

RSpec.describe PackagesFetcher do
  let(:subject) { described_class.new }

  describe '#retrieve_list' do
    before do
      expect(subject).to receive(:open)
        .with(PackagesFetcher::CRAN_SERVER_BASE_URL + 'PACKAGES')
        .and_return(File.open(File.join('spec', 'fixtures', 'files', 'PACKAGES')))
    end

    it { expect(subject.retrieve_list).to be_kind_of(Array) }
    it { expect(subject.retrieve_list).not_to be_empty }
    it { expect(subject.retrieve_list).to include(name: 'abbyyR', version: '0.5.1') }
  end

  describe '#retrieve_package' do
    let(:package_data) { subject.retrieve_package('abc', '2.1') }

    before do
      expect(subject).to receive(:open)
        .with(PackagesFetcher::CRAN_SERVER_BASE_URL + 'abc_2.1.tar.gz')
        .and_return(File.open(File.join('spec', 'fixtures', 'files', 'abc_2.1.tar.gz')))
    end

    it { expect(package_data).to be_kind_of(Hash) }
    it { expect(package_data).not_to be_nil }
    it { expect(package_data['Package']).to eq('abc') }
    it { expect(package_data['Version']).to eq('2.1') }
    it { expect(package_data['Title']).to eq('Tools for Approximate Bayesian Computation (ABC)') }
  end
end
