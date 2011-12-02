module Scraper
  @@link_grabbers = @@media_scrapers = @@media_generators = []

  class << self
    # Link grabber
    def register_link_grabber(link_grabber)
      @@link_grabbers << link_grabber
    end

    def link_grabbers
      @@link_grabbers
    end

    def link_grabbers_for(ressource)
      link_grabbers = []
      @@link_grabbers.each do |grabber|
        link_grabbers << grabber if grabber.grabber_for? ressource
      end
      link_grabbers
    end


    # Media scraper
    def register_media_scraper(media_scraper)
      @@media_scrapers << media_scraper
    end

    def media_scrapers
      @@media_scrapers
    end

    def media_scrapers_for(media)
      media_scrapers = []
      @@media_scrapers.each do |scraper|
        media_scrapers << scraper if scraper.scraper_for? media
      end
      media_scrapers
    end


    # Media Generator
    def register_media_generator(media_generator)
      @@media_generators << media_generator
    end

    def media_generators
      @@media_generators
    end

    def media_generators_for(ressource)
      media_generators = []
      @@media_generators.each do |generator|
        media_generators << generator if generator.generator_for? ressource
      end
      media_generators
    end

    # unregisters all scraper, generators, grabber etc
    # mainly used for testing purposes
    def unregister_all!
      @@media_generators = []
      @@link_grabbers = []
      @@media_scrapers = []
      self
    end
  end
end

Dir[File.join(File.dirname(__FILE__), 'scraper', '*.rb')].each do |file|
  require file
end

Dir[File.join(File.dirname(__FILE__), 'scraper_plugins', '*.rb')].each do |file|
  require file
end
