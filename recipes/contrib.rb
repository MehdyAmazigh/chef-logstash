execute "contrib" do
  cwd node['logstash']['install_path']
  command 'bin/plugin install contrib'
end
