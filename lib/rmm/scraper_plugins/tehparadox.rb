module Scraper
  class ParadoxScraper < MediaScraper
    IMG_PATTERN = /\[img\]([^\[]+)\[\/img\]/ix

    NAME_PATTERN = /<div><strong>([^<]+)<\/strong>/ix

    CODE_PATTERN = /
  (?:(\[font[^\[]+\] .*?  \[\/font\]) .*?\n|\r)?
  \[code\] (?>(?:\[[^\]]+\])*)
  (.*?) \[\/code\]
  /mix

    LINK_PATTERN = /(?:^<br[^>]*>$)|(?:(.*?)(https?:\/\/.*)(?:<br[^>]*>.*))/ix

    INFO_PATTERN = /\]([^\[]+)\[/ix

    IMDB_PATTERN = /http:\/\/(?:www\.)?imdb\.(?:[^\/]+)\/title\/([^\/]+)/ix
    
    DLC_PATTERN = /\[code\][^\[\s]{2000,}\[\/code\]/ix

    attr_reader :scraped_data

    def initialize(data)
      return {} if data.nil?

      # delete DLC code.... takes ages becouse of some more complex regexe
      # if anyone wants to optimize the regular expressions, feel free to do so :P
      data = data.gsub DLC_PATTERN, ''

      self.name = data.scan(NAME_PATTERN)[0][0]

      last_link = ["", ""]

      if data =~ IMDB_PATTERN
        self.imdb = $1
      end

      results = data.scan CODE_PATTERN
      results.each do |code|
        resource = { :urls => [], :title => "" }

        if not code[0].nil? and code[0] =~ INFO_PATTERN
          resource[:title] = $1
        end

        code[1].scan(LINK_PATTERN).each_with_index do |link, n|
          # skip if this line really contains no information whatsoever
          next if link.compact.empty? and n == 0
          next if link == last_link

          # if an IMDB link was found (Yeah!)
          next if link[1] =~ IMDB_PATTERN

          # link[0] might contain some information, but will most of the time
          # either be nil or "", so filter before trying to apply a regex to nil
          if not link[0].nil? and not link[0].empty? and link[0] =~ INFO_PATTERN
            resource[:title] = $1
          end
          
          if last_link.compact.empty?
            add_resource resource
            resource = { :urls => [] }
          end
          
          if not link.compact.empty?
            resource[:urls] << link[1]
          end

          last_link = link
        end

        add_resource resource
      end
    end
    
    def scraped_data
      res = {
        :resources => resources,
        :imdb => imdb,
        :name => name
      }
      @scraped_data ||= res
    end

    private
    attr_accessor :imdb, :name
    attr_reader :resources
    attr_writer :scraped_data

    def add_resource(res_hash)
      if res_hash[:urls].empty?
        nil
      else
        resources << Media::Resource.new(res_hash)
      end
    end

    def resources
      @resources ||= []
    end
  end
end
