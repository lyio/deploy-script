require 'spec_helper'
require 'fileutils'

describe Fio::Deploy do
  it 'has a version number' do
    expect(Fio::Deploy::VERSION).not_to be nil
  end

  describe '#delete_files' do
    before :all do
      @dir = 'build/foo'
      @file_name = "foobar.html"

      FileUtils.mkdir_p @dir
      FileUtils.mkdir_p "#{@dir}/000"
      create_file = "touch #{@dir}/#{@file_name}"
      %x[#{create_file}]
    end

    after :all do
      FileUtils.rm_r @dir
    end

    it 'raises an error if folder does not exist' do
      expect{Fio::Deploy::delete_files("#{@dir}/bar)")}
        .to raise_error(IOError, "No such directory #{@dir}/bar)")
    end

    it 'deletes files in the folder' do
      Fio::Deploy::delete_files("#{@dir}")
      expect(File.exist? "#{@dir}/#{@file_name}").to be false
    end

    it 'does not delete issue folders' do
      Fio::Deploy::delete_files("#{@dir}")
      expect(File.exist? "#{@dir}/000").to be true
    end
  end

  describe '#deploy' do
    before :each do
      @issue = "000"
      @samba = double(Fio::Samba)

      # stubbing the samba mounting
      allow(@samba).to receive_messages(:mount => 'foo', :unmount => 'bar')
      Fio::Deploy.samba = @samba
      Fio::Deploy.stub(:copy_files)
    end

    it 'fails when no issue number present' do
      expect {Fio::Deploy::deploy("#foobar") }
      .to raise_error SystemExit
    end

    it 'deletes files from share' do
      expect {Fio::Deploy::deploy("##{@issue}") }
      .to output(/deleting files for/)
      .to_stdout
    end

    it 'handles issues with 4 digits' do
      @issue = '0000'
      expect {Fio::Deploy::deploy("##{@issue}") }
        .not_to raise_error SystemExit
    end

    describe 'whole commit message' do
      before :all do
        @issue = "000"
        @branch = "master"
        @commit = "commit c055ec3982b9d516561784f6f15e87700ec6db4c
  Merge: 1ddef7c fb83cd0
  Author: Danny Hanke <d.hanke@fio.de>
  Date:   Fri Oct 23 17:22:31 2015 +0200

      Merge branch '##{@issue}-Use-new-deployment-script-for-contiuous-deployment' into '#{@branch}'

      #969 Use new deployment script for contiuous deployment

      This closes ##{@issue}

      See merge request !991"
      end

      it 'finds issue number in commit message' do

      expect {Fio::Deploy::deploy(@commit)}.to output(/#{Regexp.compile("found issue #{@issue} in commit")}/).to_stdout
      end

      it 'finds correct merge target' do
        expect {Fio::Deploy::deploy(@commit)}.to output(/#{Regexp.compile("found merge target: #{@branch}")}/).to_stdout
      end
     end

  end
end
