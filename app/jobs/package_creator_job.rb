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

      package.authors = _find_or_create_people(package_hash['Author'])
      package.maintainers = _find_or_create_people(package_hash['Maintainer'])
    end
  end

  def _find_or_create_people(people_text)
    people_parser = PackagePeopleParser.new
    people_parser.extract_people(people_text).map do |person|
      Person.find_or_create_by(name: person[:name], email: person[:email])
    end
  end
end
