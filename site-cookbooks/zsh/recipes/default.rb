#
# Cookbook:: zsh
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

file_name = "zsh-#{node['zsh']['version']}"
source_folder = "#{node['zsh']['tmp']}/#{file_name}"
remote_file "#{node['zsh']['tmp']}/#{file_name}.tar.gz" do
  source "#{node['zsh']['url']}/#{file_name}.tar.gz"
  owner "root"
  group "root"
  mode "0744"
  action :create
  notifies :run, 'execute[extract zsh]', :immediately
end

execute 'extract zsh' do
  command "tar -xvf #{source_folder}.tar.gz"
  action :nothing
  cwd node['zsh']['tmp']
  notifies :run, 'execute[configure zsh]', :immediately
end

execute 'configure zsh' do
  command './configure --prefix=/usr --with-tcsetpgrp'
  cwd source_folder
  action :nothing
  notifies :run, 'execute[compile zsh]', :immediately
end

execute 'compile zsh' do
  command 'make'
  cwd source_folder
  action :nothing
  notifies :run, 'execute[install zsh]', :immediately
end

execute 'install zsh' do
  command 'make install'
  cwd '/tmp/zsh-5.3'
  action :nothing
end
