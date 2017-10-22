# frozen_string_literal: true

class CranUriHelper
  CRAN_SERVER_BASE_URL = 'https://cran.r-project.org/src/contrib/'

  def self.packages_list_url
    CRAN_SERVER_BASE_URL + 'PACKAGES'
  end

  def self.package_file_url(name, version)
     CRAN_SERVER_BASE_URL + "#{name}_#{version}.tar.gz"
  end
end
