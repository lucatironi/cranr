# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PackageCreatorJob, type: :job do
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

  context "when the version doesn't exist" do
    it 'creates a new Package record from the given hash' do
      expect { subject.perform(package_hash) }.to change { Package.count }.by(1)

      expect(Package.last.name).to eq('abc')
      expect(Package.last.version).to eq('1.2.3')
      expect(Package.last.publication_date).to eq(Time.parse('2017-10-20 11:34:14'))
      expect(Package.last.title).to eq('Lorem ipsum')
      expect(Package.last.description).to include('Lorem ipsum dolor sit amet, consectetur adipiscing elit')

      expect(Package.last.authors).to include(Person.find_by(name: 'Tom Sawyer', email: nil))
      expect(Package.last.maintainers).to include(Person.find_by(name: 'Mark Twain', email: 'mark.twain@aol.com'))
    end

    it 'creates new authors/maintainers' do
      expect { subject.perform(package_hash) }.to change { Person.count }
    end
  end

  context 'when the version exists already' do
    before { subject.perform(package_hash) }

    it "doesn't create a new Package record" do
      expect { subject.perform(package_hash) }.not_to change { Package.count }
    end
  end

  context 'when the package exists but not the version' do
    before do
      subject.perform(package_hash)
    end

    it "doesn't create a new Package record" do
      modified_package_hash = package_hash
      modified_package_hash['Version'] = '1.3'

      expect { subject.perform(modified_package_hash) }.to change { Package.count }.by(1)

      expect(Package.last.name).to eq('abc')
      expect(Package.last.version).to eq('1.3')
    end

    it "doesn't create new authors/maintainers" do
      modified_package_hash = package_hash
      modified_package_hash['Version'] = '1.3'

      expect { subject.perform(modified_package_hash) }.not_to change { Person.count }
    end
  end
end
