# frozen_string_literal: true

require 'packages_fetcher'

class PackageIndexerJob < ApplicationJob
  queue_as :default

  def perform(package_name, package_version)
    fetcher = PackagesFetcher.new
    package_hash = fetcher.retrieve_package(package_name, package_version)

    PackageCreatorJob.perform_later(package_hash)
  end
end
