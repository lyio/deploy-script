module Fio
  module Environment

      def self.ensure_env
          abort "No samba share target provided -- aborting" unless ENV['SAMBA_SHARE']
          abort "No smb username provided -- aborting" unless ENV['SAMBA_USER']
          abort "No smb password provided -- aborting" unless ENV['SAMBA_PWD']
          abort "No build path provided -- aborting" unless ENV['BUILD_PATH']

          true
      end

  end
end
