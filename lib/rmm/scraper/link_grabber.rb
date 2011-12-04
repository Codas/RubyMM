module Scraper
  class LinkGrabber
    class << self
      def inherited(child)
        Scraper.register_link_grabber child
      end

      def grabber_for?(args)
        raise "must implement abstract method"
      end
    end
  end
end
