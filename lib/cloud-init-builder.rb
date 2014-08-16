require 'yaml'
require 'erb'
require 'fileutils'

class CloudInitBuilder < Hash
  extend FileUtils

  DATAFILE = File.expand_path(File.join File.dirname(__FILE__), '../tmp/config-drive/openstack/latest/user-data')
  UNITS_DIR = File.expand_path(File.join File.dirname(__FILE__), '../config/units-enabled')

  mkdir_p File.dirname DATAFILE

  def self.build!
    self.new.build!
  end

  def self.instructions
    @instructions ||= []
  end

  def self.instruct(&block)
    instructions << block
  end

  # Set up the coreos node
  instruct do
    @coreos = self['coreos'] = {}
    @units = @coreos['units'] = []
  end

  # build the units
  instruct do
    (Dir[File.join UNITS_DIR, '*'] - ['.keep']).each do |filename|
      name = File.basename(filename)
      content = File.read filename
      @units << {
          'name' => name,
          'command' => 'start',
          'runtime' => true,
          'enable' => true,
          'content' => content
      }
    end
  end

  def build!
    self.class.instructions.each do |instruction|
      instance_eval &instruction
    end
    File.open(DATAFILE, 'w+') do |file|
      yaml_lines = YAML.dump(to_hash).lines.map(&:rstrip)
      yaml_lines[0] = '#cloud-config'
      file.write yaml_lines.join("\n") + "\n"
    end
  end

  def to_hash
    Hash[to_a]
  end

end
