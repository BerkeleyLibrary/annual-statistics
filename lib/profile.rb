require_relative 'folderstats.rb'


class Profile
  attr_accessor :name, :root, :rules, :folder_list

  def initialize(name)
    @name = name
    @folder_list = {}
  end

  def create_stats
    process_top_level_dirs
  end

  private

  # Top Level Directories/
  def process_top_level_dirs
    tld_list = top_level_dirs root
  
    tld_list.each do |d|
      # Some top level folders we don't even want to deal with:
      # example: when running /netapp/da - you don't want netapp/da/UCBonly
      #          which gets counted separately.
      next unless rules.pass_top_level_rules? d
  
      $current_file_count = 0
      $current_byte_count = 0
  
      dir = Pathname.new(root) + d
      process_subfolder(dir)
      
      fs = FolderStats.new(d)
      fs.file_count = $current_file_count
      fs.byte_count = $current_byte_count

      folder_list[d] = fs
    end
  end

  def process_subfolder(dir)
  
    Dir.entries(dir).each do |f|
      #----------------------------------------------------#
      # Skip . and ..
      next if f.match(/^\.+$/)
  
      # Skip those pesky DS_Store files...hate those.
      next if f == '.DS_Store'
      
      #----------------------------------------------------#
      
      # Create a Pathname for this folder|file
      pn = Pathname.new(dir) + f
      
      # Thou shalt not try to count symlinks!!!!
      # Might want to count these after all... hrm.
      next if pn.symlink?
  
      if pn.directory?
        # WE HAVE A DIRECTORY - check if we should process it
        next unless rules.pass_folder_rules?(pn)

        # It passed, so let's process it!
        process_subfolder(pn.to_s)
      else
        # WE HAVE A FILE - if it passes the rules, count it!
        next unless rules.pass_file_rules?(pn)
  
        $current_file_count += 1
        $current_byte_count += pn.size
      end
      
    end
  
  end

  def top_level_dirs(root)
    Dir.chdir(root)
    Dir.glob('**').select {|f| File.directory? f}
  end
  
end