require 'json'

class Rules
  attr_accessor :rules, :top_level_rules, :sub_folder_rules, :file_rules

  def initialize
    # Config pulls the rules from the profile yaml file
    @rules = Config.rules
    
    @top_level_rules = nil
    @sub_folder_rules = nil
    @file_rules = nil
    
    process_rules
  end

  def process_rules
    return if Config.rules.nil?
    Config.rules.each do |r|
      if r['target'] == 'files'
        @file_rules = r
      elsif r['target'] == 'top_level_folder'
        @top_level_rules = r
      elsif r['target'] == 'sub_folders'
        @sub_folder_rules = r
      end
    end
  end

  def pass_top_level_rules?(dir_name)
    
    if top_level_rules

      filter = top_level_rules['filter']

      if top_level_rules['type'] == 'exclude'
        return false if filter.include? dir_name
      else
        return false unless filter.include? dir_name
      end

      return true
    end

    return true

  end

  def pass_folder_rules?(path)

    if sub_folder_rules

      filter = sub_folder_rules['filter']

      base = path.basename
      dir = path.dirname

      if sub_folder_rules['type'] == 'exclude'
        return false if filter.include? base.to_s
      else
        return false unless filter.include? base.to_s
      end

      return true
    end

    return true

  end
  
  def pass_file_rules?(path)
    
    if file_rules
      extension = path.extname.gsub('.', '')
      filter = file_rules['filter']

      if file_rules['type'] == 'exclude'
        return false if filter.include? extension.to_s
      else
        return false unless filter.include? extension.to_s
      end

      return true
    end

    return true

  end
  
end