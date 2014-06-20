case node[:platform]

when "ubuntu","debian"

execute "logstash_apt_key" do
  command " wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add - && touch /home/ubuntu/.elasticsearch_key"
  creates "/home/ubuntu/.elasticsearch_key"
  action :run
end

cookbook_file "/etc/apt/sources.list.d/elasticsearch.list" do
  source "elasticsearch.list"
  owner "root"
  group "root"
  mode "0644"
end

execute "update_apt" do
  command "apt-get update"
  action :run
end

when "centos","rhel","oracle"
#Create the Logstash Official Yum Repo
yum_repository 'logstash-1.4' do
  description "logstash repository for 1.4.x packages"
  baseurl "http://packages.elasticsearch.org/logstash/1.4/centos"
  gpgkey 'http://packages.elasticsearch.org/GPG-KEY-elasticsearch'
  action :create
  only_if { node['logstash']['install_repo'] }
end

#Install the package
package 'logstash' do
  if node['logstash']['version'] != 'latest'
    version node['logstash']['version']
  end
  action :install
  only_if { node['logstash']['install_package'] }
end
end
