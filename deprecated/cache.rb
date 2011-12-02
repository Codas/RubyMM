require 'digest/sha1'

class Cache
  CACHE_DIR = 'cache'

  attr_accessor :data

  def initialize (uri, subfolder)
    filename = Digest::SHA1.hexdigest(uri) + Time.now.to_s
  end

  private
  attr_accessor :filename

  def path
    @path ||= File.join(subfolder, filename)
  end

  # File exist and is not older than 30 minutes
  def valid?
    File.exists?(path) and File.mtime(path) - Time.now < 30*60
  end

  def invalid?
    not valid?
  end

  def get
    return nil if invalid?
    File.open(path, 'rb') do |f|
      data = f.read
    end

    data
  end

  def save
    File.mkdir(CACHE_DIR) unless File::directory?(CACHE_DIR)
    File.mkdir(subfolder) unless File::directory?(subfolder)

    File.open(path, 'w') {|f| f.write data}
  end
end
