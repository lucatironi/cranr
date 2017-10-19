require 'spec_helper'
require 'packages_list_parser'

RSpec.describe PackagesListParser do
  let(:parser) { described_class.new }
  describe '#extract' do
   let(:packages_text) {
<<-EOS
Package: A3
Version: 1.0.0
Depends: R (>= 2.15.0), xtable, pbapply
Suggests: randomForest, e1071
License: GPL (>= 2)
NeedsCompilation: no

Package: abbyyR
Version: 0.5.1
Depends: R (>= 3.2.0)
Imports: httr, XML, curl, readr, plyr, progress
Suggests: testthat, rmarkdown, knitr (>= 1.11)
License: MIT + file LICENSE
NeedsCompilation: no
EOS
    }
    let(:parsed_data) { parser.extract(packages_text) }

    context 'returns parsed data' do
      it { expect(parsed_data).to be_kind_of(Array) }
      it { expect(parsed_data.size).to be(2) }
      it { expect(parsed_data).to match_array([{ name: 'A3', version: '1.0.0' }, { name: 'abbyyR', version: '0.5.1' }]) }
    end

    context 'gracefully handles incoherent input' do
      let(:wrong_packages_text) {
<<-EOS
Library: A3
Version: 1.0.0

Package: abbyyR
Version: 0.5.1
Depends: R (>= 3.2.0)
Imports: httr, XML, curl, readr, plyr, progress
Suggests: testthat, rmarkdown, knitr (>= 1.11)
License: MIT + file LICENSE
NeedsCompilation: no

Package: foobar
Depends: R (>= 3.2.0)
EOS
      }

      it { expect(parser.extract('')).to be_empty }
      it { expect(parser.extract(1337)).to be_empty }
      it { expect(parser.extract(nil)).to be_empty }
      it { expect(parser.extract(wrong_packages_text)).to match_array([{ name: 'abbyyR', version: '0.5.1' }]) }
    end
  end
end
