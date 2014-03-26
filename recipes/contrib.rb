execute "contrib" do
  if node.logstash['install_package']
    cwd '/opt/logstash/'
  else
    cwd node['logstash']['install_path']
  end
  command 'bin/plugin install contrib'
end
