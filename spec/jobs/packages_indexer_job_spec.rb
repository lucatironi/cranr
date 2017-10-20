require 'rails_helper'

RSpec.describe PackagesIndexerJob, type: :job do
  let(:packages) { [{ name: 'A3', version: '1.0.0' }, { name: 'abbyyR', version: '0.5.1' }] }

  it 'retrieve the packages list with the PackagesFetcher' do
    expect(PackagesFetcher).to receive_message_chain(:new, :retrieve_list)
      .and_return(packages)

    subject.perform
  end

  it 'enqueues as many PackageIndexerJob jobs' do
    allow(PackagesFetcher).to receive_message_chain(:new, :retrieve_list)
      .and_return(packages)

    expect(PackageIndexerJob).to receive(:perform_later).once
      .with({ name: 'A3', version: '1.0.0' })
    expect(PackageIndexerJob).to receive(:perform_later).once
      .with({ name: 'abbyyR', version: '0.5.1' })

    subject.perform
  end
end
