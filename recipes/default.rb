#
# Cookbook Name:: collins
# Recipe:: default
#
# Copyright (c) 2014 West, William
# 
# All rights reserved - Do Not Redistribute
#
rpmurl = 'https://dl.dropboxusercontent.com/u/89454313/collins-1.2.3-1.noarch.rpm?dl=1'
version = node['collins']['version']
iteration = "1"

# the rpm takes care of user and group creation
#user node['collins']['user'] do
#  group node['collins']['group']
#  system false # need login for the setup scripts to work
#end

# needed by collins setup script 
yum_package "ruby" do
  action :install
end

# install collins from custom rpm
# TODO - get this in a repo instead of pulling from an url
remote_file "#{Chef::Config[:file_cache_path]}/collins-#{version}-#{iteration}.noarch.rpm" do 
source rpmurl
  not_if "rpm -qa | grep -q '^collins'"
  notifies :install, "rpm_package[collins]", :immediately
end

rpm_package "collins" do
  source "#{Chef::Config[:file_cache_path]}/collins-#{version}-#{iteration}.noarch.rpm"
  action :install
end 

# install libslack daemon package (collins dep)
# TODO - get this in a repo instead of pulling from an url
remote_file "#{Chef::Config[:file_cache_path]}/daemon-0.6.4-1.x86_64.rpm" do
  source "http://libslack.org/daemon/download/daemon-0.6.4-1.x86_64.rpm"
  notifies :install, "rpm_package[daemon]", :immediately
end

rpm_package "daemon" do
  source "#{Chef::Config[:file_cache_path]}/daemon-0.6.4-1.x86_64.rpm"
  action :install
end 

# the following are just ported from the manual part of the install script
template "/etc/sysconfig/collins" do
  source "etc_sysconfig_collins.erb"
  mode 0440
  owner 'root'
  group 'root'
end

template "#{node['collins']['home']}/conf/production.conf" do
  source "collins_conf_production.conf.erb"
  mode 0440
  owner node['collins']['user']
  group node['collins']['group']
end

['run','log'].each do |subdir|
  directory "/var/#{subdir}/collins" do
    owner node['collins']['user']
    group node['collins']['group']
    mode 0755
    action :create
  end
end

# expected by the initdb resource
template "/root/.my.cnf" do
  source "root_.my.cnf.erb"
  mode 0400
  owner 'root'
  group 'root'
end

# resources: initialize the database 
# some of this is redundant with the stock init script, which assumes 
# interactive 
# TODO - make these run-once (or not at all) if not Chef::Config[:solo]
bash "initdb-root" do
  code "mysql -u root -e 'create database if not exists collins;'
        mysql -u root -e \"grant all privileges on collins.* to 
                           '#{node['collins']['dbuser']}'@'127.0.0.1' 
                           identified by '#{node['collins']['dbpass']}';\"
       "
end

bash "initdb-collins" do
  code "#{node['collins']['home']}/scripts/collins.sh \
        initdb \
        #{node['collins']['dbuser']} \
        #{node['collins']['dbpass']} \
       "
  user node['collins']['user']
end

# startup
# TODO - real init scripts
bash "start-collins" do
  code "#{node['collins']['home']}/scripts/collins.sh start"
end

