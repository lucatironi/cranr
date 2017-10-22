# frozen_string_literal: true

require 'cran_uri_helper'

module PackageHelper
  def link_to_download(package)
    link_to('download', CranUriHelper.package_file_url(package.name, package.version))
  end
end
