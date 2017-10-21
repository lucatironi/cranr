# frozen_string_literal: true

# inspired by https://gist.github.com/sinisterchipmunk/1335041

require 'rubygems'
require 'rubygems/package'
require 'zlib'
require 'fileutils'

module Util
  class Tar
    # un-gzips the given IO, returning the decompressed version as a StringIO
    def ungzip(file)
      zipfile = Zlib::GzipReader.new(file)
      unzipped = StringIO.new(zipfile.read)
      zipfile.close
      unzipped
    end

    # untars the given IO into the specified directory
    def untar(io, destination)
      Gem::Package::TarReader.new(io) do |tar|
        tar.each do |file_or_dir|
          _extract_file_or_dir(file_or_dir, destination)
        end
      end
    end

    private

    def _extract_file_or_dir(file_or_dir, destination)
      destination_file = File.join(destination, file_or_dir.full_name)
      if file_or_dir.directory?
        FileUtils.mkdir_p(destination_file)
      else
        destination_directory = File.dirname(destination_file)
        FileUtils.mkdir_p(destination_directory) unless File.directory?(destination_directory)
        File.open(destination_file, 'wb') { |f| f.print(file_or_dir.read) }
      end
    end
  end
end
