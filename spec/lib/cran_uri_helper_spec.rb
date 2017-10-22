# frozen_string_literal: true

require 'spec_helper'
require 'cran_uri_helper'

RSpec.describe CranUriHelper do
  describe '.package_file_url' do
    it { expect(described_class.package_file_url('abc', '4.3.1')).to include('abc_4.3.1.tar.gz') }
  end
end
