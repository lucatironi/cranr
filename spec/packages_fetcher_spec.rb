require 'spec_helper'
require 'packages_fetcher'

RSpec.describe PackagesFetcher do
  let(:fetcher) { described_class.new }

  describe '#get_list' do
    before do
      expect(fetcher).to receive(:open)
        .with(PackagesFetcher::CRAN_SERVER_BASE_URL + 'PACKAGES')
        .and_return(File.open(File.join(File.dirname(__FILE__), 'fixtures', 'files', 'PACKAGES')))
    end

    it { expect(fetcher.get_list).to be_kind_of(Array) }
    it { expect(fetcher.get_list).not_to be_empty }
    it { expect(fetcher.get_list).to include({ name: 'abbyyR', version: '0.5.1' }) }
  end

  describe '#get_package' do
    let(:package_data) { fetcher.get_package('abc', '2.1') }

    before do
      expect(fetcher).to receive(:open)
        .with(PackagesFetcher::CRAN_SERVER_BASE_URL + 'abc_2.1.tar.gz')
        .and_return(File.open(File.join(File.dirname(__FILE__), 'fixtures', 'files', 'abc_2.1.tar.gz')))
    end

    it { expect(package_data).to be_kind_of(Hash) }
    it { expect(package_data).not_to be_nil }
    it { expect(package_data['Package']).to eq('abc') }
    it { expect(package_data['Version']).to eq('2.1') }
    it { expect(package_data['Title']).to eq('Tools for Approximate Bayesian Computation (ABC)') }
  end
end
