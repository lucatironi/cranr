# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PackagesIndexerJob, type: :job do
  let(:packages) { [{ name: 'abc', version: '1.2.3' }, { name: 'xyz', version: '3.2.1' }] }

  it 'retrieve the packages list with the PackagesFetcher' do
    expect_any_instance_of(PackagesFetcher).to receive(:retrieve_list)
      .and_return(packages)

    subject.perform
  end

  it 'enqueues as many PackageIndexerJob jobs' do
    allow_any_instance_of(PackagesFetcher).to receive(:retrieve_list)
      .and_return(packages)

    expect(PackageIndexerJob).to receive(:perform_later)
      .once
      .with(packages[0])
    expect(PackageIndexerJob).to receive(:perform_later)
      .once
      .with(packages[1])

    subject.perform
  end
end
