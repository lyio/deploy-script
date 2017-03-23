require "fio/deploy/version"
require "fio/samba"
require "fio/environment"

module Fio
    module Deploy
        DELETE_FLAG = 'This closes'

        # issue number pattern
        PATTERN = /(#)([0-9]+)/

        MNT_DIR = "/data/gitlab-runner/tmp/mnt/megane"
        @samba_share = nil
        @build_path = nil

        @samba = Fio::Samba.new

        def self.samba= value
            @samba = value
        end

        def self.deploy(commit)
            unless @samba_share
                Fio::Environment::ensure_env
                @samba_share = ENV['SAMBA_SHARE']
                @build_path = ENV['BUILD_PATH']
            end

            issue =
                if commit.match PATTERN
                    commit.match(PATTERN)[2]
                else
                    abort "no issue number in commit: #{commit}"
                end

            puts "found issue #{issue} in commit"

            target_dir = "#{MNT_DIR}/#{issue}"

            # mounting the share
            @samba.mount(MNT_DIR, @samba_share)

            # delete branch from megane
            puts "deleting files for #{issue} from megane"
            FileUtils.remove_dir target_dir if File.exist? target_dir

            if commit.include? DELETE_FLAG
                # making sure this is a merge commit with the appropriate message
                message = commit.split("\n").find do |m|
                    m.match /Merge branch .+ into 'master'/
                end

                if message
                    deploy_merge message
                else
                    @samba.unmount MNT_DIR
                    abort "Encountered delete flag without merge commit message for issue: #{issue}"
                end
            else
                deploy_feature(issue, target_dir)
            end

            # unmounting share again
            @samba.unmount MNT_DIR
        end

        private

        def self.deploy_merge(commit)
            branch = (commit.split 'into')[1].gsub("'",'').strip

            unless branch
                @samba.unmount MNT_DIR
                abort "Improperly formatted merge commit message; no target branch specified."
            end

            puts "found merge target: #{branch}"

            # if the branch was not merged into master, the build output needs to be
            # copied to the issue branch of the merge target
            if branch == 'master'
                delete_files MNT_DIR

                # copy everthing from the build folder to the target
                copy_files(@build_path, MNT_DIR)
            else
                deploy "##{branch.match(PATTERN)[2]}"
            end
        end

        def self.deploy_feature(issue, target_dir)
            # copy files over to megane
            base_url = "/megane/#{issue}/"
            puts "copy files over to #{base_url}"

            # copying files over to devsrv8
            copy_files(@build_path, target_dir)
            puts "copied #{issue} successfully"
        end

        def self.copy_files(src, dest)
            FileUtils.mkdir_p(dest) unless File.exists? dest

            Dir.foreach src do |name|
                next if name.start_with? '.'
                FileUtils.cp_r("#{src}/#{name}", dest, :verbose => true)
            end
        end

        def self.delete_files(dir)
            # getting contents of the root dir of the application and deleting everything
            # excluding folders consisting of numbers
            unless File.exist?(dir)
                @samba.unmount MNT_DIR
                raise IOError, "No such directory #{dir}"
            end

            dir = Dir.new dir
            dir.each do |name|
                unless name.start_with? '.' or name.match /^[0-9]+$/
                    puts "deleting #{dir.path}/#{name}"
                    FileUtils.remove_entry "#{dir.path}/#{name}"
                end
            end
        end
    end
end
