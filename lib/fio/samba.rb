require 'fileutils.rb'

module Fio
    class Samba
        # mounts #{share} under #{dir}
        # Ignores any errors
        def mount(dir, share)
            uid = `whoami`
            create_mount_point dir
            mount_command = "sudo mount -t cifs #{share} #{dir} -o rw,username=#{ENV['SAMBA_USER']},password=#{ENV['SAMBA_PWD']},domain=devsrv9,uid=#{uid.strip}"

            $stdout.puts "mounting megane to #{dir}"
            $stdout.puts mount_command
            
            %x[#{mount_command}]
            
            if  $?.to_i != 0
                unmount dir
                abort "Mounting failed, aborting deployment"
            end
        end

        # unmount whatever is mounted under #{dir}.
        # Ignores any errors.
        def unmount dir
            unmount = "sudo umount #{dir}"
            $stdout.puts unmount
            %x[#{unmount}]
        end

        def create_mount_point dir
            FileUtils.mkdir_p(dir) unless File.exists? dir
        end
    end
end
