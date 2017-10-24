# frozen_string_literal: true

require 'open-uri'
require 'tar'
require 'packages_list_parser'
require 'cran_uri_helper'

class PackagesListFetcher
  def retrieve
    parser = PackagesListParser.new
    list = open(CranUriHelper.packages_list_url).read
    parser.extract(list)
  end
end
