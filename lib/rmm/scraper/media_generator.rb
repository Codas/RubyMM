module Scraper
	class MediaGenerator
		# Creates a new instance of a MediaGenerator.
		#
		# @params [String] data the data the Generator has to handle
		def initialize(data)
			items = (self.respond_to? :prepare_data)? prepare_data(data): data
			populate_fields(items)
			self
		end

		private
		def populate_fields(items)
			populate_tv_shows_and_episodes(items)
			populate_games(items)
			populate_movies(items)
			populate_applications(items)
			populate_others(items)
		end

		def populate_tv_shows_and_episodes(list)
			return nil unless self.respond_to? :tv_show_items
			items = tv_show_items(list)
			
			# Iterate over every TV show that was found
			items.each do |item|
				#check if tv show with same name already exists
				if pos = self.tv_shows.index {|x| x.cmp_by_hash item[:info]}
					# and check if episode already exists
					if ep = self.tv_shows[pos].episode(item[:ep][:season], item[:ep][:episode])
						ep.add_ressource item[:ressource]
					else
						# if not, add episode to the tv show
						ep = Media::Episode.new item[:ep]
						ep.add_ressource item[:ressource]
						self.episodes << ep
						self.tv_shows[pos] << ep
					end
				else
					# if no tv_show was found
					show = Media::TVShow.new item[:info]
					ep = Media::Episode.new item[:ep]
					ep.add_ressource item[:ressource]
					self.episodes << ep
					show << ep
					self.tv_shows << show
				end
			end
		end

		def populate_games(list)
			return nil unless self.respond_to? :tv_show_items
			items = game_items(list)
			
			# Iterate over every TV show that was found
			items.each do |item|
				if pos = self.games.index{|x| x.cmp_by_hash item[:info]}
					self.games[pos].add_ressource item[:ressource]
				else
					game = Media::Game.new item[:info]
					game.add_ressource item[:ressource]
					self.games << game
				end
			end
		end

		def populate_movies(list)
			return nil unless self.respond_to? :tv_show_items
			items = movie_items(list)

			# Iterate over every TV show that was found
			items.each do |item|
				next if item.empty?

				if pos = self.movies.index{|x| x.cmp_by_hash item[:info]}
					self.movies[pos].add_ressource item[:ressource]
				else
					movie = Media::Movie.new item[:info]
					movie.add_ressource item[:ressource]
					self.movies << movie
				end
			end
		end

		def populate_applications(list)
			return nil unless self.respond_to? :tv_show_items
			items = application_items(list)

			# Iterate over every TV show that was found
			items.each do |item|
				if pos = self.applications.index{|x| x.cmp_by_hash item[:info]}
					self.movies[pos].add_ressource item[:ressource]
				else
					application = Media::Application.new item[:info]
					application.add_ressource item[:ressource]
					self.applications << item[:ressource]
				end
			end
		end

		def populate_others(list)
			return nil unless self.respond_to? :tv_show_items
			items = others_items(list)

			items.each do |item|
				if pos = self.others.index{|x| x.cmp_by_hash item[:info]}
					self.others[pos].add_ressource item[:ressource]
				else
					other = Media::Other.new item[:info]
					other.add_ressource item[:ressource]
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
			allowed = [:movies, :episodes, :tv_shows, :applications, :games, :others]
			args.push :episodes if args.include? :tv_shows
			args.each do |arg|
				raise "Invalid generator #{arg}" unless allowed.include? arg

				ivar = "@#{arg}"
				# set the getter method
				self.send :define_method, arg do
					if self.instance_variable_get ivar
						self.instance_variable_get ivar
					else
						self.instance_variable_set ivar, []
					end
				end
			end
		end
	end
end
