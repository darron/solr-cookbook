default[:jetty][:prefix] = "/opt"
default[:jetty][:path] = "/opt/jetty"
default[:jetty][:listen_ports] = "8080"
default[:jetty][:user] = "jetty"

default[:solr][:prefix] = "/opt"
default[:solr][:path] = "/opt/solr"
default[:solr][:version] = "4.2.1"
default[:solr][:url] = "http://10.0.1.10:8080/solr-4.2.1.tgz"

default[:solr_core][:url] = "https://github.com/darron/solr-nutch-core/archive/master.zip"
default[:solr_core][:folder_name] = "solr-nutch-core-master"