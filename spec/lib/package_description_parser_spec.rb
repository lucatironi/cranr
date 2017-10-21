# frozen_string_literal: true

require 'spec_helper'
require 'package_description_parser'
require 'active_support/core_ext/string'

RSpec.describe PackageDescriptionParser do
  let(:subject) { described_class.new }

  describe '#extract' do
    let(:package_description_text) do
      <<-TXT.strip_heredoc
        Package: abc
        Type: Package
        Title: Tools for Approximate Bayesian Computation (ABC)
        Version: 2.1
        Date: 2015-05-04
        Authors@R: c(
            person("Csillery", "Katalin", role = "aut", email="kati.csillery@gmail.com"),
            person("Lemaire", "Louisiane", role = "aut"),
            person("Francois", "Olivier", role = "aut"),
            person("Blum", "Michael",
            email = "michael.blum@imag.fr", role = c("aut", "cre")))
        Depends: R (>= 2.10), abc.data, nnet, quantreg, MASS, locfit
        Description: Implements several ABC algorithms for
                performing parameter estimation, model selection, and goodness-of-fit.
                Cross-validation tools are also available for measuring the
                accuracy of ABC estimates, and to calculate the
                misclassification probabilities of different models.
        Repository: CRAN
        License: GPL (>= 3)
        NeedsCompilation: no
        Packaged: 2015-05-05 08:35:25 UTC; mblum
        Author: Csillery Katalin [aut],
          Lemaire Louisiane [aut],
          Francois Olivier [aut],
          Blum Michael [aut, cre]
        Maintainer: Blum Michael <michael.blum@imag.fr>
        Date/Publication: 2015-05-05 11:34:14
      TXT
    end
    let(:parsed_data) { subject.extract(package_description_text) }

    context 'returns parsed data as a Hash' do
      it { expect(parsed_data).not_to be_nil }
      it { expect(parsed_data).to be_kind_of(Hash) }

      it { expect(parsed_data['Package']).to eq('abc') }
      it { expect(parsed_data['Version']).to eq('2.1') }
      it { expect(parsed_data['Title']).to eq('Tools for Approximate Bayesian Computation (ABC)') }
      it { expect(parsed_data['Date']).to eq('2015-05-04') }
      it { expect(parsed_data['Date/Publication']).to eq('2015-05-05 11:34:14') }
      it { expect(parsed_data['Maintainer']).to eq('Blum Michael <michael.blum@imag.fr>') }
      it {
        expect(parsed_data['Author']).to eq('Csillery Katalin [aut], Lemaire Louisiane [aut], ' \
        'Francois Olivier [aut], Blum Michael [aut, cre]')
      }
      it {
        expect(parsed_data['Description']).to eq('Implements several ABC algorithms for performing ' \
        'parameter estimation, model selection, and goodness-of-fit. Cross-validation tools are also ' \
        'available for measuring the accuracy of ABC estimates, and to calculate the misclassification ' \
        'probabilities of different models.')
      }
    end
  end
end
