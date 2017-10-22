# frozen_string_literal: true

require 'spec_helper'
require 'package_people_parser'
require 'active_support/core_ext/string'

RSpec.describe PackagePeopleParser do
  describe '#extract' do
    let(:package_authors_text) do
      <<-TXT.strip_heredoc
          Tom Sawyer [aut],
          Huck Finn [aut],
          Mark Twain <mark.twain@aol.com> [aut, cre]
      TXT
    end
    let(:package_maintainers_text) { 'Mark Twain <mark.twain@aol.com>, Tom Sawyer' }

    let(:parsed_authors) { subject.extract_people(package_authors_text) }
    let(:parsed_maintainers) { subject.extract_people(package_maintainers_text) }

    context 'returns authors' do
      it { expect(parsed_authors).not_to be_empty }
      it { expect(parsed_authors).to be_kind_of(Array) }

      it {
        expect(parsed_authors).to match_array([
                                                { name: 'Tom Sawyer', email: nil },
                                                { name: 'Huck Finn', email: nil },
                                                { name: 'Mark Twain', email: 'mark.twain@aol.com' }
                                              ])
      }
    end

    context 'returns maintainers' do
      it { expect(parsed_maintainers).not_to be_empty }
      it { expect(parsed_maintainers).to be_kind_of(Array) }

      it {
        expect(parsed_maintainers).to match_array([
                                                    { name: 'Mark Twain', email: 'mark.twain@aol.com' },
                                                    { name: 'Tom Sawyer', email: nil }
                                                  ])
      }
    end
  end
end
