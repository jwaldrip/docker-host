require 'fileutils'
require 'lib/cloud-init-builder'

$vb_memory = 8192
$vb_cpus = 4
$coreos_update_channel = "alpha"
$coreos_version = '>= 386.1.0'

# Create the cloud config if vagrant is not up
if !File.exist?(CloudInitBuilder::DATAFILE) || (ARGV.first == 'up' && `vagrant status | grep 'docker-'`.include?('not created'))
  puts "\e[0;34;49mBuilding new cluster configuration!\e[0m"
  CloudInitBuilder.build!
end
