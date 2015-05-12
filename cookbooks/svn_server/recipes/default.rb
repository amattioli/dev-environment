#
# Cookbook Name:: svn_server
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

#include_recipe 'apache2::default'
include_recipe 'apache2::mod_dav'
include_recipe 'apache2::mod_dav_svn'

package 'subversion' do
  action :install
end

package 'subversion-tools'
package 'libsvn-perl'

directory node['subversion']['repo_dir'] do
  owner node['apache']['user']
  group node['apache']['user']
  mode '0755'
  recursive true
end

web_app 'subversion' do
  template 'subversion.conf.erb'
  server_name "#{node['subversion']['server_name']}.#{node['domain']}"
  notifies 'restart[apache2]'
end

execute 'svnadmin create repo' do
  command "svnadmin create --config-dir /home/#{node['apache']['user']}/.subversion #{node['subversion']['repo_dir']}/#{node['subversion']['repo_name']}"
  creates "#{node['subversion']['repo_dir']}/#{node['subversion']['repo_name']}"
  user node['apache']['user']
  group node['apache']['user']
end

package 'apache2-utils' if platform_family?('debian', 'suse') && node['apache']['version'] == '2.4'

execute 'create htpasswd file' do
  command "htpasswd -scb #{node['subversion']['repo_dir']}/htpasswd #{node['subversion']['user']} #{node['subversion']['password']}"
  creates "#{node['subversion']['repo_name']}/htpasswd"
end

