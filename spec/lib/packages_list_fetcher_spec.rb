# frozen_string_literal: true

require 'spec_helper'
require 'packages_list_fetcher'
require 'cran_uri_helper'

RSpec.describe PackagesListFetcher do
  describe '#retrieve' do
    before do
      allow(subject).to receive(:open)
        .with(CranUriHelper.packages_list_url)
        .and_return(File.open(File.join('spec', 'fixtures', 'files', 'PACKAGES')))
    end

    it { expect(subject.retrieve).to be_kind_of(Array) }
    it { expect(subject.retrieve).not_to be_empty }
    it { expect(subject.retrieve).to include(name: 'abbyyR', version: '0.5.1') }
  end
end
