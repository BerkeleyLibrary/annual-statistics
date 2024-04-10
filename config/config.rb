require 'erb'
require 'yaml'
require 'json'

class Config
  @@profile = ''

  # General Settings: Uses ERB for ENV variables
  yaml_contents = File.read('config/profiles.yml')
  @settings = YAML.safe_load(ERB.new(yaml_contents).result)

  def self.set_profile(root)
    @@profile = root

    unless @settings[@@profile]
      puts "\nERROR: No stat profile named '#{root}' exists."
      exit
    end
  end

  # Returns specified field value from settings.yml
  def self.setting(field)
    @settings[@@profile][field] || nil
  end

  def self.settings
    @settings
  end

  def self.rules
    @settings[@@profile]['rules']
  end

  def self.help
    puts "HEEEELLLLP!!!\n\nHahahahaha!"
  end
end