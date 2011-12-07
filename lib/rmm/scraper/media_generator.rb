module Scraper
  class MediaGenerator
    attr_reader :data

    # Creates a new instance of a MediaGenerator.
    #
    # @params [String] data the data the Generator has to handle
    def initialize(data)
      self.data = (self.respond_to? :prepare_data)? prepare_data(data): data
      self
    end

    private
    attr_writer :data

    def populate_tv_shows()
      return nil unless self.respond_to? :tv_show_items
      items = tv_show_items(self.data)

      # Iterate over every TV show that was found
      items.each do |item|
        #check if tv show with same name already exists
        if pos = self.tv_shows.index {|x| x.cmp_by_hash item[:info]}
          # and check if episode already exists
          if ep = self.tv_shows[pos].episode(item[:ep])
            ep.add_resource Media::Resource.new(item[:resource])
          else
            # if not, add episode to the tv show
            ep = Media::Episode.new item[:ep]
            ep.add_resource Media::Resource.new(item[:resource])
            self.tv_shows[pos] << ep
          end
        else
          # if no tv_show was found
          show = Media::TVShow.new item[:info]
          ep = Media::Episode.new item[:ep]
          ep.add_resource Media::Resource.new(item[:resource])
          show << ep
          self.tv_shows << show
        end
      end
    end

    def populate_games()
      return nil unless self.respond_to? :game_items
      items = game_items(self.data)

      # Iterate over every TV show that was found
      items.each do |item|
        if pos = self.games.index{|x| x.cmp_by_hash item[:info]}
          self.games[pos].add_resource Media::Resource.new(item[:resource])
        else
          game = Media::Game.new item[:info]
          game.add_resource Media::Resource.new(item[:resource])
          self.games << game
        end
      end
    end

    def populate_movies()
      return nil unless self.respond_to? :movie_items
      items = movie_items(self.data)

      # Iterate over every TV show that was found
      items.each do |item|
        next if item.empty?
        if pos = self.movies.index{|x| x.cmp_by_hash item[:info]}
          self.movies[pos].add_resource Media::Resource.new(item[:resource])
        else
          movie = Media::Movie.new item[:info]
          movie.add_resource Media::Resource.new(item[:resource])
          self.movies << movie
        end
      end
    end

    def populate_applications()
      return nil unless self.respond_to? :application_items
      items = application_items(self.data)

      # Iterate over every TV show that was found
      items.each do |item|
        if pos = self.applications.index{|x| x.cmp_by_hash item[:info]}
          self.applications[pos].add_resource Media::Resource.new(item[:resource])
        else
          application = Media::Application.new item[:info]
          application.add_resource Media::Resource.new(item[:resource])
          self.applications << application
        end
      end
    end

    def populate_others()
      return nil unless self.respond_to? :other_items
      items = other_items(self.data)

      items.each do |item|
        if pos = self.others.index{|x| x.cmp_by_hash item[:info]}
          self.others[pos].add_resource Media::Resource.new(item[:resource])
        else
          other = Media::Other.new item[:info]
          other.add_resource Media::Resource.new(item[:resource])
          self.others << other
        end
      end
    end


    class << self
      private
      def inherited(child)
        Scraper.register_media_generator child
      end

      def generator_for?(args)
        raise "must implement abstract method"
      end
    end

    def self.generates(*args)
      # TODO: this wil probably be needed elsewhere too. Check
      # back here some time soon...
      allowed = [:movies, :tv_shows, :applications, :games, :others]
      args.each do |arg|
        raise "Invalid generator #{arg}" unless allowed.include? arg

        ivar = "@#{arg}"
        # set the getter method
        self.send :define_method, arg do
          # when @#{ivar} is not defined (nil), set @{ivar} = []
          # and invoke the populate_#{arg} method to populate the movie,
          # tv_show etc list. the instance variable needs to be set beforhand in
          # order to avoid a nasty recursion
          if self.instance_variable_get ivar
            self.instance_variable_get ivar
          else
            self.instance_variable_set ivar, []
            self.send "populate_#{arg}".to_sym
            self.instance_variable_get ivar
          end
        end
      end
    end
  end
end
