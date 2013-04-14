#
# Cookbook Name:: solr
# Recipe:: secure
#

# Setup firewall rules as required.
solr_access_ips = []

search(:solr_http_access, '*:*') do |ip_address|
  solr_access_ips << ip_address['ip']
  
  # Remote Solr Access
  execute ip_address['ip'] do
    command "/usr/sbin/ufw allow from #{ip_address['ip']} to any port #{node[:jetty][:listen_ports]}"
  end

end