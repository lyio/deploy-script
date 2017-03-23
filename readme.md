[![build status](http://devsrv2/ci/projects/2/status.png?ref=master)](http://devsrv2/ci/projects/2?ref=master)

# Gitlab CI deploy script

This script handles *continuous deployment* for the [Fioport.Vermarktung] frontend, deploying to the *megane* server for testing and QA.

It handles extraction of the current issue number from the supplied commit message, renames the */build* folder to the issue number.

It also mounts a network share on devsrv8 and copies the */build* folder over, making the
current branch available to QA under `megane/#{issue}`.

If the commit is a merge commit that closes an issue, the script will detect a configurable
text in the commit message and attempt to delete the folder from megane.

It will also erase everything in the root folder of megane (excluding the issue sub folders) and copy over the newly build fronten application.

## Usage

The script expects a Git commit message on **STDIN** containing a GitLab issue number prefixed by `#` as part of the commit message. It will exit in all other cases.
It will be installed as part of its own build process and is available as an executable on the $PATH.
```bash
git log -1 | sudo fio-deploy.rb
```

## Development

The deployment script is written in Ruby and is designed to be run on a Linux machine. This is due to the fact that the
CI Runner that calls this script is also on a Linux machine.
Since most developers here do not have Linux development machines this would be quite hard to develop for.
To make this easier and to simulate in an environment as close to the actual production environment as possible the project runs in a virtual machine.

### Vagrant

Not everyone wants to setup their own virtual machine and install all the required software/libraries. And this would also be detrimental
to the efforts of simulating a production like environment.
This project uses a virtual machine manager called *Vagrant* to do all this automatically. All you need to do is
to install [Virtualbox] and [Vagrant].

Vagrant takes care of creating a virtual machine image and provisioning this image. After installing Vagrant you can start the virtual machine with ```vagrant up```
in the root directory of the project. The ```Vagrantfile``` tells vagrant what kind of machine we want and how to provision it.
In this case we provision with a simple shell script. You can see what is installed in ```bootstrap.sh```.

After provisioning is done, the virtual machine is ready to go. It is a headless vm so do not expect any output. You then simply
use ```vagrant ssh``` to ssh into the machine and then have your files available in the
directory ```/vagrant```.

### Bundler

For packaging, scaffolding and dependency management we use *Bundler*. The virtual machine has an alias set for running the tests
so in the ```/vagrant``` directory simply type ```test``` to run all the tests.

To try out the packaging and installing part simply type ```bundle exec rake install```. This packages the Gem and installs
it locally.

[Fioport.Vermarktung]: http://devsrv2/fio/fioport-vermarktung
[Vagrant]: http://www.vagrantup.com/downloads.html
[VirtualBox]: https://www.virtualbox.org/wiki/Downloads
