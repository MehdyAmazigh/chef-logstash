
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
