Dir[File.join(File.dirname(__FILE__), 'media', '*.rb')].each do |file|
  require file
end

module Media
  module CanAddResource
    # adds a resource (a hash with mandatory url key) to the
    # list of resources ONLY if there is not already a resource
    # available with the same url
    def add_resource(resource)
      self.resources ||= []

      unless self.resources.index {|x| x.urls == resource.urls}
        self.resources << resource 
        resource
      else nil
      end
    end
  end

  class Resource
    attr_accessor :title, :urls, :tags

    def initialize(params = {})
      params.each do |k, v|
        self.send("#{k}=".to_sym, v)
      end
      self
    end
  end
  
  class TVShow
    attr_accessor :rating
    attr_reader :episodes, :seasons, :name

    def initialize(params)
      params.each do |k, v|
        self.send("#{k}=".to_sym, v)
      end
      self.name.strip!
      self
    end

    def episode(s, e = nil)
      if s.class == String and (res = s.match /s(\d+)e|\.|-(\d+)/i)
        id = [res[1].to_i, res[2].to_i]
      elsif s.class == Hash and s[:season] and s[:episode]
        id = [s[:season].to_i, s[:episode].to_i]
      else
        id = [s.to_i, e.to_i]
      end
      self.episodes.select{|e|e.season == id[0] and e.episode == id[1]}.first
    end

    def episodes
      @episodes ||= []
    end

    def << (episode)
      episode.tv_show = self
      self.episodes << episode
    end

    def cmp_by_hash(hash)
      self.name.downcase == hash[:name].downcase.strip
    end

    private
    attr_writer :name
  end

  class Episode
    include CanAddResource

    attr_accessor :season, :episode, :tv_show, :resources
    attr_accessor :name, :rating, :runtime, :air_date
    attr_reader :dl_date

    def initialize(params)
      params.each do |k, v|
        self.send("#{k}=".to_sym, v)
      end
      self.season = self.season.to_i
      self.episode = self.episode.to_i
      self
    end
  end

  class Movie
    include CanAddResource

    attr_accessor :year, :resources
    attr_reader :dl_date, :name

    def initialize(params)
      params.each do |k, v|
        self.send("#{k}=".to_sym, v)
      end
      self.year = year.to_i
      self
    end

    def cmp_by_hash(hash)
      self.name.downcase == hash[:name].downcase.strip and
        self.year == hash[:year].to_i
    end

    private
    attr_writer :name
  end

  class Application
    include CanAddResource

    attr_accessor :resources
    attr_reader :name


    def initialize(params)
      params.each do |k, v|
        self.send("#{k}=".to_sym, v)
      end
      self
    end

    def cmp_by_hash(hash)
      self.name.downcase == hash[:name].downcase.strip
    end

    private
    attr_writer :name
  end

  class Game
    include CanAddResource

    attr_accessor :resources
    attr_reader :name


    def initialize(params)
      params.each do |k, v|
        self.send("#{k}=".to_sym, v)
      end
      self
    end

    def cmp_by_hash(hash)
      self.name.downcase == hash[:name].downcase
    end
    
    private
    attr_writer :name
  end
  
  class Other
    include CanAddResource

    attr_accessor :resources
    attr_reader :name


    def initialize(params)
      params.each do |k, v|
        self.send("#{k}=".to_sym, v)
      end
      self
    end

    def cmp_by_hash(hash)
      self.name.downcase == hash[:name].downcase
    end
    
    private
    attr_writer :name
  end
end
