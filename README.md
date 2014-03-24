# logstash cookbook

# Requirements

# Usage
Currently Logstash will be installed from the elasticsearch Yum repos, versions 1.4+ are available.

Recommended install method is using a wrapper cookbook with templates for your config files. Be sure to set the following attributes:
`node['logstash]['server']['config_templates'] = ['example']
node['logstash]['server']['config_templates_cookbook'] = 'mycookbook'
node['logstash]['server']['config_templates_variables'] = { 'example' => 'some variable used in your templates' }
`
Then you can install by including the 'logstash::server' recipe

# Attributes

# Recipes
packages - manages install of the elasticsearch repo and logstash package
server - sets up configurations pieces for logstash and manages the service

# Author

Author:: Ryan O'Keeffe (rdokeeffe@spscommerce.com)
