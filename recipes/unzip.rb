#
# Cookbook Name:: collins
# Recipe:: unzip
#
# Copyright (c) 2014 West, William
# 
# All rights reserved - Do Not Redistribute
#

# this is actually a latent dependency of the java_extras cookbook
yum_package "unzip" do
  action :install
end
