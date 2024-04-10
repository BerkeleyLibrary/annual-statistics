class FolderStats
  attr_accessor :name, :file_count, :byte_count

  def initialize(name)
    @name = name
    @file_count = 0
    @byte_count = 0
  end

  def megabytes
    @byte_count.to_f / 1024 / 1024
  end
  
end