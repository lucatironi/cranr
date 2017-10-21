# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PackageCreatorJob, typer: :job do
  let(:package_hash) do
    {
      'Package' => 'abc',
      'Type' => 'Package',
      'Title' => 'Tools for Approximate Bayesian Computation (ABC)',
      'Version' => '2.1',
      'Date' => '2015-05-04',
      'Authors@R' => 'c( person("Csillery", "Katalin", role = "aut", email="kati.csillery@gmail.com"), ' \
        'person("Lemaire", "Louisiane", role = "aut"), person("Francois", "Olivier", role = "aut"), ' \
        'person("Blum", "Michael", email = "michael.blum@imag.fr", role = c("aut", "cre")))',
      'Depends' => 'R (>= 2.10), abc.data, nnet, quantreg, MASS, locfit',
      'Description' => 'Implements several ABC algorithms for performing parameter estimation, model selection' \
        ', and goodness-of-fit. Cross-validation tools are also available for measuring the accuracy of ABC ' \
        'estimates, and to calculate the misclassification probabilities of different models.',
      'Repository' => 'CRAN',
      'License' => 'GPL (>= 3)',
      'NeedsCompilation' => 'no',
      'Packaged' => '2015-05-05 08:35:25 UTC; mblum',
      'Author' => 'Csillery Katalin [aut], Lemaire Louisiane [aut], Francois Olivier [aut], Blum Michael [aut, cre]',
      'Maintainer' => 'Blum Michael <michael.blum@imag.fr>',
      'Date/Publication' => '2015-05-05 11:34:14'
    }
  end

  context "when the version doesn't exist" do
    it 'creates a new Package record from the given hash' do
      expect { subject.perform(package_hash) }.to change { Package.count }.by(1)

      expect(Package.last.name).to eq('abc')
      expect(Package.last.version).to eq('2.1')
      expect(Package.last.publication_date).to eq(Time.parse('2015-05-05 11:34:14'))
      expect(Package.last.title).to eq('Tools for Approximate Bayesian Computation (ABC)')
      expect(Package.last.description).to include('Implements several ABC algorithms for performing')

      expect(Package.last.maintainers).to include(Person.find_by(name: 'Blum Michael', email: 'michael.blum@imag.fr'))
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
      modified_package_hash['Version'] = '2.2'

      expect { subject.perform(modified_package_hash) }.to change { Package.count }.by(1)

      expect(Package.last.name).to eq('abc')
      expect(Package.last.version).to eq('2.2')
    end

    it "doesn't create new authors/maintainers" do
      modified_package_hash = package_hash
      modified_package_hash['Version'] = '2.2'

      expect { subject.perform(modified_package_hash) }.not_to change { Person.count }
    end
  end
end
