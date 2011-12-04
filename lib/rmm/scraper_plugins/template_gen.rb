module Scraper
  class TemplateGenor < MediaGenerator
    TV_SHOW_PATTERN     = //
    MOVIES_PATTERN      = //
    OTHERS_PATTERN      = //
    GAMES_PATTERN       = //
    APPLICATION_PATTERN = //
    
    # The Classes this generator generate content for. Will also create 
    # basic getter for these attributes and will default to empty array []
    generates :movies, :tv_shows, :applications, :games, :others

    # if you need to prepare your raw data before sending it to your
    # xxx_items methods, HERE is the place to do so.
    #
    # @param [String] data the data to prepare. Will most likey be a string but
    #   can more or less be anything scrapable
    # @return anything your xxx_items methods can handle
    def prepare_data(data)
      data.gsub(/Do some fancy data manipulation here/, '')
    end

    # Formats the data in a format that the TVShow generator can handle.
    # Has to conform to a certain standard:
    #   
    #   [
    #     :info      => {...},
    #     :ep        => {...},
    #     :ressource => {...}
    #   ]
    #
    # **info**: The info hash use to create the tv_show object
    #   see {Media::TVShow#initialize} for a list of available options
    #   note that only one TVShow per unique name will be generated.
    #
    # **ep**: The episode hash used to create the episode. See
    #   {Media::Episode#initialize} for more information.
    #
    # **ressource**: The ressource hash used to create the ressource for the
    #   newly added TVShow. Can be either an array of ressource hashed or just 
    #   one hash. See {Media::Episode#initialize} for more information on
    #   ressource hashes.
    #
    # @param [#prepare_data] data The output of #prepare_data, otherwhise the
    #   data supplied to the constructor
    # @return [array] the array of hashes
    def tv_show_items(data)
      data.map { |x| x.match TV_SHOW_PATTERN}.compact.map do |item|
        item = {
          :info => {
            :name => ''
          },
          :ep => {
            :season  => '',
            :episode => ''
          },
          :ressource => {
            :resolution => '',
            :source     => '',
            :url        => '',
          }
        }
      end
    end

    # Formats the data in a format that the Game generator can handle.
    # Has to conform to a certain standard:
    #   
    #   [
    #     :info      => {...},
    #     :ressource => {...}
    #   ]
    #
    # **info**: The info hash use to create the object
    #   see {Media::Game#initialize} for a list of available options
    #   note that only one object per unique name will be generated.
    #
    # **ressource**: The ressource hash used to create the ressource for the
    #   newly added object. Can be either an array of ressource hashed or just 
    #   one hash. See {Media::Game#initialize} for more information on
    #   ressource hashes.
    #
    # @param (see #tv_show_items)
    # @return (see #tv_show_items)
    def game_items(data)
      data.map { |x| x.match GAMES_PATTERN}.compact.map do |item|
        item = {
          :info => {
            :name => ''
          },
          :ressource => {
            :release_group => '',
            :url           => ''
          }
        }
      end
    end

    # Formats the data in a format that the Movie generator can handle.
    # Has to conform to a certain standard:
    #   
    #   [
    #     :info      => {...},
    #     :ressource => {...}
    #   ]
    #
    # **info**: The info hash use to create the object
    #   see {Media::Movie#initialize} for a list of available options
    #   note that only one object per unique name will be generated.
    #
    # **ressource**: The ressource hash used to create the ressource for the
    #   newly added object. Can be either an array of ressource hashed or just 
    #   one hash. See {Media::Movie#initialize} for more information on
    #   ressource hashes.
    #
    # @param (see #tv_show_items)
    # @return (see #tv_show_items)
    def movie_items(data)
      data.map { |x| x.match MOVIES_PATTERN}.compact.map do |item|
        item = {
          :info => {
            :name => '',
            :year => ''
          },
          :ressource => {
            :resolution => '',
            :source     => '',
            :url        => ''
          }
        }
      end
    end

    # Formats the data in a format that the Application generator can handle.
    # Has to conform to a certain standard:
    #   
    #   [
    #     :info      => {...},
    #     :ressource => {...}
    #   ]
    #
    #
    # **info**: The info hash use to create the object
    #   see {Media::Application#initialize} for a list of available options
    #   note that only one object per unique name will be generated.
    #
    # **ressource**: The ressource hash used to create the ressource for the
    #   newly added object. Can be either an array of ressource hashed or just 
    #   one hash. See {Media::Application#initialize} for more information on
    #   ressource hashes.
    #
    # @param (see #tv_show_items)
    # @return (see #tv_show_items)
    def application_items(data)
      data.map { |x| x.match APPLICATION_PATTERN}.compact.map do |item|
        item = {
          :info => {
            :name => ''
          },
          :ressource => {
            :url => ''
          }
        }
      end
    end

    # Formats the data in a format that the Movie generator can handle.
    # Has to conform to a certain standard:
    #   
    #   [
    #     :info      => {...},
    #     :ressource => {...}
    #   ]
    #
    # **info**: The info hash use to create the object
    #   see {Media::Others#initialize} for a list of available options
    #   note that only one object per unique name will be generated.
    #
    # **ressource**: The ressource hash used to create the ressource for the
    #   newly added object. Can be either an array of ressource hashed or just 
    #   one hash. See {Media::Others#initialize} for more information on
    #   ressource hashes.
    #
    # @param (see #tv_show_items)
    # @return (see #tv_show_items)
    def other_items(data)
      data.map { |x| x.match OTHERS_PATTERN}.compact.map do |item|
        item = {
          :info => {
            :name => ''
          },
          :ressource => {
            :url => ''
          }
        }
      end
    end

    class << self
      # generator_for? is used to determine weather or not this generator
      # is used for the supplied ressource (url as string) or not
      #
      # @param [String] ressource the url
      # @return [Boolean] weather the gerator is capable of handling this
      #   ressource or not
      def generator_for?(ressource)
        false
      end
    end
  end
end
