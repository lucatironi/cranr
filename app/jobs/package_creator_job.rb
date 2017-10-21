# frozen_string_literal: true

require 'package_people_parser'

class PackageCreatorJob < ApplicationJob
  queue_as :default

  def perform(package_hash)
    _find_or_create_package(package_hash)
  end

  private

  def _find_or_create_package(package_hash)
    Package.find_or_create_by(name: package_hash['Package'], version: package_hash['Version']) do |package|
      package.publication_date = Time.parse(package_hash['Date/Publication'])
      package.title = package_hash['Title']
      package.description = package_hash['Description']
    end
  end
end
