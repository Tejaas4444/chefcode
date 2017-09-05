#
# Cookbook Name:: iis_install
# Recipe:: default
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

#
# Cookbook Name:: windowsweb_demo
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reser

dsc_resource 'webserver' do
  resource :windowsfeature
  property :name, 'Web-Server'
  property :ensure, 'Present'
end

dsc_resource 'dotnet45' do
  resource :windowsfeature
  property :name, 'Web-Asp-Net45'
  property :ensure, 'Present'
end

windows_firewall_rule 'iis' do
	localport '80'
	protocol 'TCP'
	firewall_action :allow
end

include_recipe 'iis::remove_default_site'

docroot = "C:\\inetpub\\icons"


directory docroot do
  rights :modify, 'IIS_IUSRS'
end

iis_pool 'icons' do
  runtime_version '4.0'
  pipeline_mode :Integrated
  action :add
end

iis_site 'icons' do
  protocol :http
  port 80
  path docroot
  application_pool 'icons'
  action [:add, :start]
end


