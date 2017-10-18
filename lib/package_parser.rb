class PackageParser
  def initialize(text)
    @text = text
    @data = []
  end

  def extract
    return [] unless @text.is_a?(String)
    @text.split("\n\n").each do |package_metadata|
      matched_data = /Package\:\s(?<name>\w+)\nVersion\:\s(?<version>\S+)/.match(package_metadata)
      @data << { name: matched_data[:name], version: matched_data[:version] } unless matched_data.nil?
    end
    return @data
  end
end
