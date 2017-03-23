require 'spec_helper'
require 'fio/samba'
require 'fileutils'

describe Fio::Samba do
    before :all do
        @dir = 'build/mnt/test'
        @share = "'test'"
        @mnt_cmd_regex = "sudo mount -t cifs #{@share} #{@dir}"
    end

    before :each do
        allow($?).to receive(:to_i).and_return 0
    end

    after :all do
        FileUtils.rm_r @dir
    end
     
    subject {Fio::Samba.new}
    
    describe '#mount' do
        it 'outputs correct mount command' do
              subject.should_receive(:`).with("whoami").once.and_return "under_test"
              subject.should_receive(:`).with(/#{Regexp.compile(@mnt_cmd_regex)}/).once.and_return 0
              subject.mount(@dir, @share)
        end
        
        it 'creates mount folder' do 
            subject.should_receive(:`).with("whoami").once.and_return "under_test"
            subject.should_receive(:`).with(/#{Regexp.compile(@mnt_cmd_regex)}/).once.and_return 0
            subject.mount(@dir, @share)
            expect(File.exist?(@dir)).to eq true
        end
        
        it 'uses user name from environment' do
            subject.should_receive(:`).with("whoami").once.and_return "under_test"
            subject.should_receive(:`).with(/username=test_user_name/).once.and_return 0
            subject.mount(@dir, @share)
       end
       
       it 'uses password from environment' do
            subject.should_receive(:`).with("whoami").once.and_return "under_test"
            subject.should_receive(:`).with(/password=pwd/).once.and_return 0
            subject.mount(@dir, @share)
        end
        
        it 'aborts execution on mount errors' do
            allow($?).to receive(:to_i).and_return 1
            subject.should_receive(:`).with("whoami").once.and_return "under_test"
            
            subject.should_receive(:`).with(/sudo umount/)
            subject.should_receive(:`).with(/sudo mount/).once.and_return 'some error'
            expect {subject.mount(@dir, @share)}
                .to raise_error SystemExit
        end
    end
    
    describe '#unmount' do
        it 'should call umount' do
            subject.should_receive(:`).with("sudo umount #{@dir}").once
            subject.unmount @dir
        end
    end
end