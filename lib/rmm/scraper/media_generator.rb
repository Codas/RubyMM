module Scraper
	class MediaGenerator
		attr_reader :tv_shows, :episodes, :games, :movies, :applications, :others

		class << self
			def inherited(child)
				Scraper.register_media_generator child
			end

			def generator_for?(args)
				raise "must implement abstract method"
			end
		end

		####################################################
		# basic getter and setter

		def movies
			@movies ||= []
		end

		def games
			@games ||= []
		end

		def applications
			@applications ||= []
		end

		def others
			@others ||= []
		end

		def episodes
			@episodes ||= []
		end

		def tv_shows
			@tv_shows ||= []
		end

	end
end
