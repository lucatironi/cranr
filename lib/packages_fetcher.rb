# frozen_string_literal: true

require 'open-uri'
require 'tar'

class PackagesFetcher
  CRAN_SERVER_BASE_URL = 'https://cran.r-project.org/src/contrib/'

  def initialize
    @list_parser = PackagesListParser.new
    @description_parser = PackageDescriptionParser.new
  end

  def retrieve_list
    list = open(CRAN_SERVER_BASE_URL + 'PACKAGES').read
    @list_parser.extract(list)
  end

  def retrieve_package(name, version)
    package_file = open(CRAN_SERVER_BASE_URL + "#{name}_#{version}.tar.gz")

    Dir.mktmpdir do |tmp_dir|
      Util::Tar.new.untar(Util::Tar.new.ungzip(package_file), tmp_dir)

      @description_parser.extract(File.read(File.join(tmp_dir, name, 'DESCRIPTION')))
    end
  end
end
