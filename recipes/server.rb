if node.logstash['install_package'] == true
  #Install the package for logstash
  include_recipe "logstash::packages"
else
  #Not implemented
  raise 'No install method implemented other than package at this time'
end

#Setup configuration
#If using the package (currently supported install method), most init changes are in /etc/sysconfig/logstash
#LS_HEAP_SIZE
#LS_JAVA_OPTS
#LS_WORKER_THREADS
#LS_CONF_DIR=/etc/logstash/conf.d

#Setup the configuration files via templates.  Take an array for template names, a cookbook to source, and an hash for the variables
unless node['logstash']['server']['config_templates'].nil? || node['logstash']['server']['config_templates'].empty?
  node['logstash']['server']['config_templates'].each do |config_template|
    template "/etc/logstash/conf.d/#{config_template}.conf" do
      source "#{config_template}.conf.erb"
      cookbook node['logstash']['server']['config_templates_cookbook']
      owner 'logstash'
      group 'logstash'
      mode '0644'
      variables node['logstash']['server']['config_templates_variables'][config_template]
      if node['logstash']['server']['service_enable']
        notifies :restart, "service[logstash]", :delayed
      end
      action :create
    end
  end
end

#Do some service stuff if required
if node.logstash.server['service_enable'] == true
  service 'logstash' do
    supports :restart => true
    action :enable
  end
end

#check version file for non-conformance
ruby_block 'clean up version file' do
  block do
    fileedit = Chef::Util::FileEdit.new('/opt/logstash/lib/logstash/version.rb')
    fileedit.search_file_delete(/(-modified)/)
    fileedit.write_file
  end
end

if node.logstash.server['install_contrib'] == true
  include_recipe "logstash::contrib"
end
