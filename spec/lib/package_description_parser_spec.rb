# frozen_string_literal: true

require 'spec_helper'
require 'package_description_parser'
require 'active_support/core_ext/string'

RSpec.describe PackageDescriptionParser do
  describe '#extract' do
    let(:package_description_text) do
      <<-TXT.strip_heredoc
        Package: abc
        Type: Package
        Title: Lorem ipsum
        Version: 1.2.3
        Date: 2017-10-20
        Authors@R: c(
            person("Tom", "Sawyer", role = "aut"),
            person("Huck", "Finn", role = "aut"),
            person("Mark", "Twain", email = "mark.twain@aol.com", role = c("aut", "cre")))
        Depends: R (>= 2.10)
        Description: Lorem ipsum dolor sit amet, consectetur adipiscing elit,
                sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut
                enim ad minim veniam, quis nostrud exercitation
        Repository: CRAN
        License: GPL (>= 3)
        NeedsCompilation: no
        Packaged: 2017-10-20 08:35:25 UTC; mblum
        Author: Tom Sawyer [aut],
          Huck Finn [aut],
          Mark Twain [aut, cre]
        Maintainer: Mark Twain <mark.twain@aol.com>
        Date/Publication: 2017-10-20 11:34:14
      TXT
    end
    let(:parsed_data) { subject.extract(package_description_text) }

    context 'returns parsed data as a Hash' do
      it { expect(parsed_data).not_to be_nil }
      it { expect(parsed_data).to be_kind_of(Hash) }

      it { expect(parsed_data['Package']).to eq('abc') }
      it { expect(parsed_data['Version']).to eq('1.2.3') }
      it { expect(parsed_data['Title']).to eq('Lorem ipsum') }
      it { expect(parsed_data['Date']).to eq('2017-10-20') }
      it { expect(parsed_data['Date/Publication']).to eq('2017-10-20 11:34:14') }
      it { expect(parsed_data['Maintainer']).to eq('Mark Twain <mark.twain@aol.com>') }
      it {
        expect(parsed_data['Author']).to eq('Tom Sawyer [aut], Huck Finn [aut], Mark Twain [aut, cre]')
      }
      it {
        expect(parsed_data['Description']).to eq('Lorem ipsum dolor sit amet, consectetur adipiscing elit, ' \
        'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut ' \
        'enim ad minim veniam, quis nostrud exercitation')
      }
    end
  end
end
