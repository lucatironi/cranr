# frozen_string_literal: true

require 'package_description_fetcher'

class PackageIndexerJob < ApplicationJob
  queue_as :default

  def perform(package)
    fetcher = PackageDescriptionFetcher.new
    package_hash = fetcher.retrieve(package[:name], package[:version])

    PackageCreatorJob.perform_later(package_hash)
  end
end
