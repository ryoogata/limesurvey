#
# Cookbook Name:: limesurvey
# Recipe:: default
#
# Copyright 2014, Ryo Ogata
#
# All rights reserved - Do Not Redistribute
#

case node['platform']
when "centos"
  %w{
    php-mbstring php-imap
  }.each do |package_name|
    package package_name do
      action :install
    end
  end
when "ubuntu"
end

git "#{node['apache']['docroot_dir']}/limesurvey" do
  repository "git://github.com/LimeSurvey/LimeSurvey.git"
  reference "master"
  action :sync
end

script "change owner and permission" do
  interpreter "bash"
  cwd "#{node['apache']['docroot_dir']}"
  code <<-EOH
    chgrp -R #{node['apache']['user']} limesurvey
    chmod -R 775 limesurvey/tmp
    chmod -R 775 limesurvey/upload
    chmod -R 775 limesurvey/application/config
  EOH
end
