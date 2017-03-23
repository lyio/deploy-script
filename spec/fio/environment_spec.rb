require 'spec_helper'
require 'fio/environment'

describe 'Fio::Environment' do
   it 'should return true if all variables are set' do
     expect(Fio::Environment.ensure_env).to be true
   end

   it 'aborts if SAMBA is not set' do
     toggle_env 'SAMBA_SHARE'
     expect {Fio::Environment::ensure_env}
       .to raise_error SystemExit
     toggle_env 'SAMBA_SHARE'
   end

   it 'aborts if SAMBA_USER is not set' do
     toggle_env 'SAMBA_USER'
     expect {Fio::Environment::ensure_env}
       .to raise_error SystemExit
     toggle_env 'SAMBA_USER'
   end

   it 'aborts if SAMBA_PWD is not set' do
     toggle_env 'SAMBA_PWD'
     expect {Fio::Environment::ensure_env}
       .to raise_error SystemExit
     toggle_env 'SAMBA_PWD'
   end

   it 'aborts if BUILD_PATH is not set' do
     toggle_env 'BUILD_PATH'
     expect {Fio::Environment::ensure_env}
       .to raise_error SystemExit
     toggle_env 'BUILD_PATH'
   end
end
