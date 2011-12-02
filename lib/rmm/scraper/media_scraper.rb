module Scraper
	class MediaScraper
		class << self
			def inherited(child)
				Scraper.register_media_scraper child
			end

			def scraper_for?(args)
				raise "must implement abstract method"
			end
		end
	end
end
