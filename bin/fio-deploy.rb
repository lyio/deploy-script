require 'fio/deploy.rb'
require 'fio/environment.rb'

# make sure proper environment variables are set
Fio::Environment::ensure_env

# take commit message from stdin
commit = ARGF.inject do |acc, l| acc.concat l end
# ignoring empty commits
if commit && !commit.empty?
	Fio::Deploy::deploy commit
else
	$stderr.puts "ignoring empty commits"
end
