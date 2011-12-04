module Scraper
  class CardmanThread < MediaGenerator
    # All constans are only used to keep all the regexes in one nice place
    # they don't fulfill any greater goal or are needed for anything
    # outside this class or file
    # FIXME: constants should not really be used here, make them methods
    #   or something like that.

    PARADOX_PRINT_LINK = "http://tehparadox.com/forum/printthread.php?t="

    SOURCES = %w[blu-ray bluray web-dl hdtv dvd dvdrip hdrip]

    TV_SHOW_PATTERN = /
      ^ .*\/f73\/
      (.*)
      -(?:s(\d+)e(\d+))
      -(?:\w+-)?
      (\d{3,4}(?:p|i))
      -(\w+)
      -.*
      -(\d+)
    /ix

    MOVIES_PATTERN = /
      ^.*\/f89\/
      (.*)
      -(\d{4,4})
      -(?:.*?)
      (\d{3,4}(?:p|i))
      -(\w+)
      -.*
      -(\d+)
    /ix

    APPLICATION_PATTERN = /^.*\/f51\/ (.*) - (\d+) \//ix

    OTHERS_PATTERN = /^.*\/f73\/ (.*) - (\d+) \//ix

    GAMES_PATTERN = /^.*\/f43\/ (.*) - ([^-]+) - (\d+) \//ix

    # The Classes this generator generate content for. Will also create 
    # basic getter for these attributes and will default to empty array []
    generates :movies, :tv_shows, :applications, :games, :others

    # scan for everything inside [url]...[/url]
    def prepare_data(data)
      regex = /\[url\]([^\[]+)\[\/url\]/i
      data.scan(regex).flatten
    end

    # prepare data for inserting into TVShow and Episode objects
    def tv_show_items(data)
      source = nil
      data.map { |x| x.match TV_SHOW_PATTERN}.compact.map do |item|
        source = item[0][/#{SOURCES.join('|')}/ix]
        item = {
          :info => {
            :name => item[1].split('-').map{ |e| e.capitalize }.join(' '),
          },
          :ep => {
            :season  => item[2].to_i,
            :episode => item[3].to_i
          },
          :ressource => {
            :resolution => item[4],
            :source     => item[5],
            :url        => PARADOX_PRINT_LINK + item[6]
          }
        }
      end
    end

    # Prepare data for inserting into Game object
    def game_items(data)
      data.map { |x| x.match GAMES_PATTERN}.compact.map do |item|
        item = {
          :info => {
            :name => item[1].split('-').map{ |e| e.capitalize }.join(' '),
          },
          :ressource => {
            :release_group => item[2],
            :url           => PARADOX_PRINT_LINK + item[3]
          }
        }
      end
    end

    # prepare data for inserting into Movie object
    def movie_items(data)
      source = nil
      data.map { |x| x.match MOVIES_PATTERN}.compact.map do |item|
        source = item[0][/#{SOURCES.join('|')}/ix]
        item = {
          :info => {
            :name => item[1].split('-').map{ |e| e.capitalize }.join(' '),
            :year => item[2]
          },
          :ressource => {
            :resolution => item[3],
            :source     => source || item[4],
            :url        => PARADOX_PRINT_LINK + item[5]
          }
        }
      end
    end

    # Prepare data for inserting into Application object
    def application_items(data)
      data.map { |x| x.match APPLICATION_PATTERN}.compact.map do |item|
        item = {
          :info => {
            :name => item[1].split('-').map{ |e| e.capitalize }.join(' '),
          },
          :ressource => {
            :url        => PARADOX_PRINT_LINK + item[2]
          }
        }
      end
    end

    # prepare data for inserting into Others object
    def other_items(data)
      others = data.select { |x| x !~ TV_SHOW_PATTERN and x =~ /\/f73\// }
      others.map { |x| x.match OTHERS_PATTERN}.compact.map do |item|
        item = {
          :info => {
            :name => item[1].split('-').map{ |e| e.capitalize }.join(' '),
          },
          :ressource => {
            :url => PARADOX_PRINT_LINK + item[2]
          }
        }
      end
    end

    class << self
      # Only use this scraper for the special cardman thread on tehparadox.com
      def generator_for?(ressource)
        pattern = /http:\/\/tehparadox.com\/forum\/printthread\.php\?t=1439182/
        !! ressource.url =~ pattern
      end
    end
  end
end
