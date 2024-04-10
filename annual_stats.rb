require 'rubygems'
require 'bundler/setup'
require 'pathname'
require 'getoptlong'

require_relative 'config/config'
require_relative 'lib/rules'
require_relative 'lib/profile'


opts = GetoptLong.new(
  ['--help', '-h', GetoptLong::NO_ARGUMENT],
  ['--root', '-r', GetoptLong::REQUIRED_ARGUMENT]
)

opts.each do |opt, arg|
  case opt
  when '--help'
    puts Config.help
    exit
  when '--root'
    @root = arg
  end
end

# Set (get really) our profile from the profiles.yml file
Config.set_profile @root

# Preserve the current working directory
workding_dir = Dir.getwd

# Get our name, root path and define the filename we'll write to
name = Config.setting 'name'
root = Config.setting 'root'
outfile = "stats_#{Config.setting 'name'}.csv"


# Define our profile object
profile = Profile.new(name)

# Pass it the root path (parrent directory)
profile.root = root

# Create a rules object and pass it into the profile
profile.rules = Rules.new

# Go ahead and create the stats
profile.create_stats

puts "OUTFILE: #{outfile}"


# Change back to the preserved working directory to write our file
Dir.chdir(workding_dir)

out = File.open(outfile, 'w')
out.write "FOLDER, FILE_COUNT, B, M\n"

profile.folder_list.sort.map do |folder, rf|
  out.write "#{folder.to_s}, #{rf.file_count}, #{rf.byte_count}, #{rf.megabytes.round(2)}\n"
end

out.close

puts "\nCOMPLETED: #{outfile}\n"
