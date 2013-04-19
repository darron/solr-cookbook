require File.expand_path('../support/helpers', __FILE__)

describe 'solr::default' do

  include Helpers::Solr
  # Example spec tests can be found at http://git.io/Fahwsw
  
  it "installs the unzip package" do
    package("unzip").must_be_installed
  end

  it "installs the curl package" do
    package("curl").must_be_installed
  end

  it 'should change ulimits for solr' do
  	assert_file "/etc/security/limits.d/solr.conf", "root", "root", "644"
  end

  it "creates the solr directory" do
    assert_directory node[:solr][:path], node[:jetty][:user], node[:jetty][:user], 0755
  end

  it "creates the cores directory" do
    assert_directory "#{node[:solr][:path]}/cores", node[:jetty][:user], node[:jetty][:user], 0755
  end

  it "creates the first core " do
    assert_directory "#{node[:solr][:path]}/cores/core1", node[:jetty][:user], node[:jetty][:user], 0755
  end

  it "installs the solr war file" do
    assert_file "#{node[:jetty][:path]}/webapps/solr.war", 'root', 'root', 0755
  end
  
  it "installs the solr.xml file" do
    assert_file "#{node[:solr][:path]}/solr.xml", node[:jetty][:user], node[:jetty][:user], 0644
  end
  
  

end