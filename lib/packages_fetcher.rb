# frozen_string_literal: true

require 'open-uri'
require 'tar'
require 'packages_list_parser'
require 'package_description_parser'
require 'cran_uri_helper'

class PackagesFetcher
  def initialize
    @list_parser = PackagesListParser.new
    @description_parser = PackageDescriptionParser.new
  end

  def retrieve_list
    list = open(CranUriHelper.packages_list_url).read
    @list_parser.extract(list)
  end

  def retrieve_package(name, version)
    package_file = open(CranUriHelper.package_file_url(name, version))

    Dir.mktmpdir do |tmp_dir|
      Util::Tar.new.untar(Util::Tar.new.ungzip(package_file), tmp_dir)

      @description_parser.extract(File.read(File.join(tmp_dir, name, 'DESCRIPTION')))
    end
  end
end
