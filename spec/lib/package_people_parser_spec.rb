# frozen_string_literal: true

require 'spec_helper'
require 'package_people_parser'
require 'active_support/core_ext/string'

RSpec.describe PackagePeopleParser do
  let(:subject) { described_class.new }

  describe '#extract' do
    let(:package_authors_text) do
      <<-TXT.strip_heredoc
          Csillery Katalin [aut, cre],
          Lemaire Louisiane [aut],
          Francois Olivier [aut],
          Blum Michael <michael.blum@imag.fr> [aut, cre]
      TXT
    end
    let(:package_maintainers_text) { 'Blum Michael <michael.blum@imag.fr>, Csillery Katalin' }

    let(:parsed_authors) { subject.extract_people(package_authors_text) }
    let(:parsed_maintainers) { subject.extract_people(package_maintainers_text) }

    context 'returns authors' do
      it { expect(parsed_authors).not_to be_empty }
      it { expect(parsed_authors).to be_kind_of(Array) }

      it {
        expect(parsed_authors).to match_array([
                                                { name: 'Csillery Katalin', email: nil },
                                                { name: 'Lemaire Louisiane', email: nil },
                                                { name: 'Francois Olivier', email: nil },
                                                { name: 'Blum Michael', email: 'michael.blum@imag.fr' }
                                              ])
      }
    end

    context 'returns maintainers' do
      it { expect(parsed_maintainers).not_to be_empty }
      it { expect(parsed_maintainers).to be_kind_of(Array) }

      it {
        expect(parsed_maintainers).to match_array([
                                                    { name: 'Blum Michael', email: 'michael.blum@imag.fr' },
                                                    { name: 'Csillery Katalin', email: nil }
                                                  ])
      }
    end
  end
end
