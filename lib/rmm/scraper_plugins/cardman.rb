module Scraper
  class CardmanThread < MediaGenerator
		PARADOX_PRINT_LINK = "http://tehparadox.com/forum/printthread.php?t="

		TV_SHOW_PATTERN = /
			^
			.*\/f\d+\/
			(.*)
			-(?:s(\d+)e(\d+))
			-(?:\w+-)?
			(\d{3,4}(?:p|i))
			-(\w+)
			-.*
			-(\d+)
		/ix

		MOVIES_PATTERN = /^
			.*\/f\d+\/
			(.*)
			-(\d{4,4})
			-(?:\w+-)?
			(\d{3,4}(?:p|i))
			-(\w+)
			-.*
			-(\d+)
		/ix

		APPLICATION_PATTERN = /^.*\/f\d+\/ (.*) - (\d+) \//ix

		GAMES_PATTERN = /^.*\/f\d+\/ (.*) - ([^-]+) - (\d+) \//ix

		def initialize(data)
			regex = /\[url\]([^\[]+)\[\/url\]/
			items = data.scan(regex)
			populate_fields(items)
			self
		end

		def populate_fields(items)
			populate_tv_shows_and_episodes(items)
			populate_games(items)
			populate_movies(items)
			populate_applications(items)
			populate_others(items)
		end

		####################################################
		# everything related to TV Shows

		def populate_tv_shows_and_episodes(items)
			urls = urls_to_tv_shows(items)
			infos = urls.map {|x| x.scan TV_SHOW_PATTERN}.flatten(1)

			# initiate some vars so they don't need to be initialized for every loop
			pos = nil
			show = nil

			# Iterate over every TV show that was found
			infos.each do |info|
			 	# assign all the infos to nice hashes
				show_hash = {
					:name => info[0].split('-').map { |e| e.capitalize }.join(' '),
				} 
				ep_hash = {
					:season  => info[1].to_i,
					:episode => info[2].to_i
				}
				ressource = {
					:resolution => info[3],
					:source => info[4],
					:url => PARADOX_PRINT_LINK + info[5]
				}
				
				#check if tv show with same name already exists
				if pos = self.tv_shows.index {|x| x.cmp_by_hash show_hash}
					# and check if episode already exists
					if ep = self.tv_shows[pos].episode(ep_hash[:season], ep_hash[:episode])
						ep.add_ressource ressource
					else
						# if not, add episode to the tv show
						ep = Media::Episode.new ep_hash
						ep.add_ressource ressource
						self.episodes << ep
						self.tv_shows[pos] << ep
					end
				else
					# if no tv_show was found
					show = Media::TVShow.new show_hash
					ep = Media::Episode.new ep_hash
					ep.add_ressource ressource
					self.episodes << ep
					show << ep
					self.tv_shows << show
				end
			end
		end

		def urls_to_tv_shows(items)
			shows = items.flatten.select { |x| x =~ /\/f73\/([^\/])/}
			shows.select { |x| x =~ TV_SHOW_PATTERN }
		end

		####################################################
		# everything related to Games

		def populate_games(items)
			urls = urls_to_games(items)
			infos = urls.map {|x| x.scan GAMES_PATTERN}.flatten(1)

			# initiate some vars so they don't need to be initialized for every loop
			pos = nil
			show = nil

			# Iterate over every TV show that was found
			infos.each do |info|
				games_hash = {
					:name => info[0].split('-').map{ |e| e.capitalize }.join(' '),
				}
				ressource = {
					:release_group => info[1],
					:url => PARADOX_PRINT_LINK + info[2]
				}

				if pos = self.games.index{|x| x.cmp_by_hash games_hash}
					self.games[pos].add_ressource ressource
				else
					game = Media::Game.new games_hash
					game.add_ressource ressource
					self.games << game
				end
			end
		end

		def urls_to_games(items)
			items.flatten.select { |x| x =~ /\/f43\//}
		end

		####################################################
		# everything related to Movies

		def populate_movies(items)
			urls = urls_to_movies(items)
			infos = urls.map {|x| x.scan MOVIES_PATTERN}.flatten(1)

			# initiate some vars so they don't need to be initialized for every loop
			pos = nil
			show = nil

			# Iterate over every TV show that was found
			infos.each do |info|
				movie_hash = {
					:name => info[0].split('-').map{ |e| e.capitalize }.join(' '),
					:year => info[1]
				}
				ressource = {
					:resolution => info[2],
					:source => info[3],
					:url => PARADOX_PRINT_LINK + info[4]
				}

				if pos = self.movies.index{|x| x.cmp_by_hash movie_hash}
					self.movies[pos].add_ressource ressource
				else
					movie = Media::Movie.new movie_hash
					movie.add_ressource ressource
					self.movies << movie
				end
			end
		end

		def urls_to_movies(items)
			items.flatten.select { |x| x =~ /\/f89\//}
		end

		####################################################
		# everything related to Applications

		def populate_applications(items)
			urls = urls_to_applications(items)
			infos = urls.map {|x| x.scan APPLICATION_PATTERN}.flatten(1)

			# initiate some vars so they don't need to be initialized for every loop
			pos = nil
			show = nil

			# Iterate over every TV show that was found
			infos.each do |info|
				application_hash = {
					:name => info[0].split('-').map{ |e| e.capitalize }.join(' '),
				}
				ressource = {
					:url => PARADOX_PRINT_LINK + info[1]
				}

				if pos = self.applications.index{|x| x.cmp_by_hash application_hash}
					self.movies[pos].add_ressource ressource
				else
					application = Media::Application.new application_hash
					application.add_ressource ressource
					self.applications << application
				end
			end
		end

		def urls_to_applications(items)
			items.flatten.select { |x| x =~ /\/f51\//}
		end

		####################################################
		# everything related to other items

		def populate_others(items)
			urls = urls_to_others(items)
			infos = urls.map {|x| x.scan GAMES_PATTERN}.flatten(1)

			# initiate some vars so they don't need to be initialized for every loop
			pos = nil
			show = nil

			# Iterate over every TV show that was found
			infos.each do |info|
				others_hash = {
					:name => info[0].split('-').map{ |e| e.capitalize }.join(' '),
				}
				ressource = {
					:url => PARADOX_PRINT_LINK + info[1]
				}

				if pos = self.others.index{|x| x.cmp_by_hash others_hash}
					self.others[pos].add_ressource ressource
				else
					other = Media::Other.new others_hash
					other.add_ressource ressource
					self.others << other
				end
			end
		end

		def urls_to_others(items)
			shows = items.flatten.select { |x| x =~ /\/f73\//}
			shows.select { |x| x !~ TV_SHOW_PATTERN }
		end

		####################################################
		# Class level methods
		 
		class << self
			def generator_for?(ressource)
				pattern = /http:\/\/tehparadox.com\/forum\/printthread\.php\?t=1439182/
				!! ressource.url =~ pattern
			end
		end
  end
end
