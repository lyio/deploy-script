sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install -y build-essential
sudo apt-get install -y ruby1.9.3
sudo apt-get install git -y
sudo gem install bundler -y
sudo apt-get install ruby-dev zlib1g-dev

sudo mkdir -p /data/gitlab-runner/tmp/mnt/megane
sudo echo "alias test='bundle exec rake spec'" >> ~/.bashrc
mkdir ~/build
