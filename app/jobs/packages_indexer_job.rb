# frozen_string_literal: true

class PackagesIndexerJob < ApplicationJob
  queue_as :default

  def perform
    fetcher = PackagesFetcher.new
    packages = fetcher.retrieve_list

    packages.each do |package|
      PackageIndexerJob.perform_later(package)
    end
  end
end
