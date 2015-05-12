#
# Cookbook Name:: jenkins_server
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#include_recipe 'apt::default'
#include_recipe 'java::default'

#node.override['jenkins']['master']['install_method'] = 'war'

#Install Jenkins
include_recipe 'jenkins::java'
include_recipe 'jenkins::master'

#Global configuration
Chef::Log.info("Java home: #{node['jenkins']['java']}")

template "#{node['jenkins']['master']['home']}/config.xml" do
  source "config.xml.erb"
end

template "#{node['jenkins']['master']['home']}/hudson.tasks.Maven.xml" do
  source 'hudson.tasks.Maven.xml.erb'
end

jenkins_command 'reload-configuration'

#Job creation
job_config = File.join(Chef::Config[:file_cache_path], 'job-config.xml')

template job_config do
  source 'webapp-job-config.xml.erb'
end

jenkins_job 'Webapp' do
  config job_config
end

