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
      data = prepare_data(data)
      fetch_generic!(data)

      last_link = ["", ""]

      data.scan(CODE_PATTERN).each do |code|
        resource = { :urls => [], :title => "" }

        resource[:title] = get_title(code)

        code[1].scan(LINK_PATTERN).each_with_index do |link, n|
          # skip if this line really contains no information whatsoever
          next if link.compact.empty? and n == 0
          next if link == last_link
          next if link[1] =~ IMDB_PATTERN

          resource[:title] = get_title(link)
          
          if last_link.compact.empty?
            add_resource resource
            resource = { :urls => [] }
          end
          resource[:urls] << link[1] unless link.compact.empty?

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

    def prepare_data(data)
      # delete DLC code.... takes ages becouse of some more complex regexe
      # if anyone wants to optimize the regular expressions, feel free to do so :P
      data.gsub DLC_PATTERN, ''
    end

    def get_title(data)
      if not data[0].nil? and data[0] =~ INFO_PATTERN
        $1
      else ""
      end
    end

    def fetch_generic!(data)
      self.name = data.scan(NAME_PATTERN)[0][0]

      if data =~ IMDB_PATTERN
        self.imdb = $1
      end
    end

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
