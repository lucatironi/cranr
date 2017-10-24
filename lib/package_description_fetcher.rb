# frozen_string_literal: true

require 'open-uri'
require 'tar'
require 'package_description_parser'
require 'cran_uri_helper'

class PackageDescriptionFetcher
  def retrieve(name, version)
    parser = PackageDescriptionParser.new
    package_file = open(CranUriHelper.package_file_url(name, version))

    Dir.mktmpdir do |tmp_dir|
      Util::Tar.new.untar(Util::Tar.new.ungzip(package_file), tmp_dir)

      parser.extract(File.read(File.join(tmp_dir, name, 'DESCRIPTION')))
    end
  end
end
