# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PackageIndexerJob, type: :job do
  let(:package) { { name: 'abc', version: '1.2.3' } }
  let(:package_hash) do
    {
      'Package' => 'abc',
      'Type' => 'Package',
      'Title' => 'Lorem ipsum',
      'Version' => '1.2.3',
      'Date' => '2017-10-20',
      'Authors@R' => 'c( person("Tom", "Sawyer", role = "aut"), ' \
        'person("Huck", "Finn", role = "aut"), ' \
        'person("Mark", "Twain", email = "mark.twain@aol.com", role = c("aut", "cre")))',
      'Depends' => 'R (>= 2.10)',
      'Description' => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, ' \
          'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut ' \
          'enim ad minim veniam, quis nostrud exercitation',
      'Repository' => 'CRAN',
      'License' => 'GPL (>= 3)',
      'NeedsCompilation' => 'no',
      'Packaged' => '2017-10-20 08:35:25 UTC; mblum',
      'Author' => 'Tom Sawyer [aut], Huck Finn [aut], Mark Twain [aut, cre]',
      'Maintainer' => 'Mark Twain <mark.twain@aol.com>',
      'Date/Publication' => '2017-10-20 11:34:14'
    }
  end

  it 'retrieve the package hash with the PackagesFetcher' do
    expect(PackagesFetcher).to receive_message_chain(:new, :retrieve_package)
      .with(package[:name], package[:version])
      .and_return(package_hash)

    subject.perform(package)
  end

  it 'enqueue a PackageCreatorJob job' do
    allow(PackagesFetcher).to receive_message_chain(:new, :retrieve_package)
      .with(package[:name], package[:version])
      .and_return(package_hash)

    expect(PackageCreatorJob).to receive(:perform_later)
      .once
      .with(package_hash)

    subject.perform(package)
  end
end
