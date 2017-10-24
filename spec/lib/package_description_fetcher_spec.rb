# frozen_string_literal: true

require 'spec_helper'
require 'package_description_fetcher'
require 'cran_uri_helper'

RSpec.describe PackageDescriptionFetcher do
  describe '#retrieve' do
    let(:package_data) { subject.retrieve('abc', '2.1') }

    before do
      allow(subject).to receive(:open)
        .with(CranUriHelper.package_file_url('abc', '2.1'))
        .and_return(File.open(File.join('spec', 'fixtures', 'files', 'abc_2.1.tar.gz')))
    end

    it { expect(package_data).to be_kind_of(Hash) }
    it { expect(package_data).not_to be_nil }
    it { expect(package_data['Package']).to eq('abc') }
    it { expect(package_data['Version']).to eq('2.1') }
    it { expect(package_data['Title']).to eq('Tools for Approximate Bayesian Computation (ABC)') }
  end
end
