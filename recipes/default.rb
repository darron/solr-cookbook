#
# Cookbook Name:: solr
# Recipe:: default
#
# Copyright (C) 2013 Darron Froese
# 
# All rights reserved - Do Not Redistribute
#

# Install Jetty and Java.
include_recipe "jetty::default"

# Install Solr.
service "jetty" do
  action [ :nothing ]
end

package "unzip"
package "curl"

cookbook_file "/etc/security/limits.d/solr.conf" do
  owner "root"
  group "root"
  mode "0644"
  action :create
end

ark "solr" do
  url node[:solr][:url]
  version node[:solr][:version]
  owner node[:jetty][:user]
  action :install
end

directory node[:solr][:path] do
  owner node[:jetty][:user]
  group node[:jetty][:user]
  mode 0755
  action :create
end

directory "#{node[:solr][:path]}/cores" do
  owner node[:jetty][:user]
  group node[:jetty][:user]
  mode 0755
  action :create
end

ark "core1" do
  url node[:solr_core][:url]
  owner node[:jetty][:user]
  action :put
  path "#{node[:solr][:path]}/cores/"
end

bash "install solr" do
  user "root"
  cwd node[:solr][:prefix]
  code <<-EOH
    cp /usr/local/solr/dist/solr-#{node[:solr][:version]}.war #{node[:jetty][:path]}/webapps/solr.war
    cp -R /usr/local/solr/example/solr/* #{node[:solr][:path]}
    cp -R /usr/local/solr/dist #{node[:solr][:path]}
    cp -R /usr/local/solr/contrib #{node[:solr][:path]}
    chown -R #{node[:jetty][:user]}.#{node[:jetty][:user]} #{node[:solr][:path]}
  EOH
  not_if { FileTest.exists?("#{node[:jetty][:path]}/webapps/solr.war") }
end

# Only install new solr.xml if it's the default install.
template "#{node[:solr][:path]}/solr.xml" do
  source "solr.erb"
  owner node[:jetty][:user]
  group node[:jetty][:user]
  mode "0644"
  action :create
  notifies :restart, "service[jetty]"
  only_if "grep collection1 #{node[:solr][:path]}/solr.xml"
end

template "#{node[:solr][:path]}/create-core.sh" do
  source "create-core.erb"
  owner node[:jetty][:user]
  group node[:jetty][:user]
  mode "0755"
  variables(
    :solr_core => node[:solr_core][:url],
    :solr_path => node[:solr][:path],
    :folder_name => node[:solr_core][:folder_name],
    :jetty_user => node[:jetty][:user],
    :jetty_port => node[:jetty][:listen_ports]
  )
  action :create
end

template "#{node[:solr][:path]}/unload-core.sh" do
  source "unload-core.erb"
  owner node[:jetty][:user]
  group node[:jetty][:user]
  mode "0755"
  variables(
    :solr_path => node[:solr][:path],
    :jetty_port => node[:jetty][:listen_ports]
  )
  action :create
end

template "#{node[:solr][:path]}/rebuild.sh" do
  source "rebuild.erb"
  owner node[:jetty][:user]
  group node[:jetty][:user]
  mode "0755"
  variables(
    :solr_path => node[:solr][:path],
    :jetty_user => node[:jetty][:user]
  )
  action :create
end

template "#{node[:solr][:path]}/README.txt" do
  source "readme.erb"
  owner node[:jetty][:user]
  group node[:jetty][:user]
  mode "0644"
  variables(
    :solr_path => node[:solr][:path]
  )
  action :create
end
