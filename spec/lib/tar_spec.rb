# frozen_string_literal: true

require 'spec_helper'
require 'tar'

RSpec.describe Util::Tar do
  describe '#ungzip' do
    let(:gzip_file) { File.open(File.join('spec', 'fixtures', 'files', 'abc_2.1.tar.gz')) }
    let(:uncompressed_file) { Util::Tar.new.ungzip(gzip_file) }

    it { expect(uncompressed_file.string).to start_with('abc') }
    it { expect(uncompressed_file).to be_kind_of(StringIO) }
  end

  describe '#untar' do
    it 'extracts the content of the tar file in a destination directory' do
      Dir.mktmpdir do |tmp_dir|
        tar_file = File.open(File.join('spec', 'fixtures', 'files', 'abc_2.1.tar'))
        Util::Tar.new.untar(tar_file, tmp_dir)

        expect(File.read(File.join(tmp_dir, 'abc', 'DESCRIPTION'))).not_to be_nil
      end
    end
  end
end
