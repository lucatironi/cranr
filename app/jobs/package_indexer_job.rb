# frozen_string_literal: true

require 'packages_fetcher'

class PackageIndexerJob < ApplicationJob
  queue_as :default

  def perform(package)
    fetcher = PackagesFetcher.new
    package_hash = fetcher.retrieve_package(package[:name], package[:version])

    PackageCreatorJob.perform_later(package_hash)
  end
end
