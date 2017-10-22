# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PackageIndexerJob, type: :job do
  let(:package) { { name: 'abc', version: '2.1' } }
  let(:package_hash) { {} }

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
