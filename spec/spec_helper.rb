ENV_VARS = {'SAMBA_SHARE' => 'foobar', 'SAMBA_USER' => 'test_user_name', 'SAMBA_PWD' => 'pwd', 'BUILD_PATH' => 'build'}

# setting env vars for tests
ENV['SAMBA_SHARE'] = ENV_VARS['SAMBA_SHARE']
ENV['SAMBA_USER'] = ENV_VARS['SAMBA_USER']
ENV['SAMBA_PWD'] = ENV_VARS['SAMBA_PWD']
ENV['BUILD_PATH'] = ENV_VARS['BUILD_PATH']

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'fio/deploy'

def toggle_env(var)
    ENV[var] = ENV[var] ? nil : ENV_VARS[var]
end
