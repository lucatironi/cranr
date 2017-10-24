# frozen_string_literal: true

require 'packages_list_fetcher'

class PackagesIndexerJob < ApplicationJob
  queue_as :default

  def perform
    fetcher = PackagesListFetcher.new
    packages = fetcher.retrieve

    packages.take(50).each do |package|
      PackageIndexerJob.perform_later(package)
    end
  end
end
