class PackagesListParser
  def initialize
    @packages = []
  end

  def extract(text)
    return [] unless text.is_a?(String)
    text.split("\n\n").each do |package_metadata|
      matched_data = /Package\:\s(?<name>\w+)\nVersion\:\s(?<version>\S+)/.match(package_metadata)
      @packages << { name: matched_data[:name], version: matched_data[:version] } unless matched_data.nil?
    end
    return @packages
  end
end
