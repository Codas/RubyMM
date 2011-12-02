Dir[File.join(File.dirname(__FILE__), 'media', '*.rb')].each do |file|
  require file
end

module Media
	module Ressource
		# adds a ressource (a hash with mandatory url key) to the
		# list of ressources ONLY if there is not already a ressource
		# available with the same url
		def add_ressource(ressource)
			self.ressources ||= []
			unless self.ressources.index {|x| x[:url] == ressource[:url]}
				self.ressources << ressource 
				ressource
			else nil
			end
		end
	end
	
  class TVShow
    attr_accessor :rating, :display_name
    attr_reader :episodes, :seasons, :name

		def initialize(params)
			params.each do |k, v|
				self.send("#{k}=".to_sym, v)
			end
			
			# clone real name to display name and downcase show name (identifier)
			# for more reliable comparability
			self.display_name = self.name.clone
			self.name = self.name.downcase

			self
		end

		def episode(s, e)
			nil
		end

		def episodes
			@episodes ||= []
		end

		def << (episode)
			episode.tv_show = self
			self.episodes << episode
		end

		def cmp_by_hash(hash)
			self.name == hash[:name].downcase
		end

		private
		attr_writer :name
  end

  class Episode
		include Ressource

    attr_accessor :season, :episode, :tv_show, :ressources
		attr_accessor :name, :rating, :runtime, :air_date
    attr_reader :dl_date

		def initialize(params)
			params.each do |k, v|
				self.send("#{k}=".to_sym, v)
			end
			self
		end
	end

  class Movie
		include Ressource

    attr_accessor :display_name, :year, :ressources
    attr_reader :dl_date, :name

		def initialize(params)
			params.each do |k, v|
				self.send("#{k}=".to_sym, v)
			end
			# clone real name to display name and downcase show name (identifier)
			# for more reliable comparability
			self.display_name = self.name.clone
			self.name = self.name.downcase
			self
		end

		def cmp_by_hash(hash)
			self.name == hash[:name].downcase and self.year == hash[:year].to_i
		end

		private
		attr_writer :name
  end

  class Application
		include Ressource

		attr_accessor :display_name, :ressources
		attr_reader :name


		def initialize(params)
			params.each do |k, v|
				self.send("#{k}=".to_sym, v)
			end
			# clone real name to display name and downcase show name (identifier)
			# for more reliable comparability
			self.display_name = self.name.clone
			self.name = self.name.downcase
			self
		end

		private
		attr_writer :name
  end

  class Game
		include Ressource

		attr_accessor :display_name, :ressources
		attr_reader :name


		def initialize(params)
			params.each do |k, v|
				self.send("#{k}=".to_sym, v)
			end
			# clone real name to display name and downcase show name (identifier)
			# for more reliable comparability
			self.display_name = self.name.clone
			self.name = self.name.downcase
			self
		end

		def cmp_by_hash(hash)
			self.name == hash[:name]
		end
		
		private
		attr_writer :name
  end
	
	class Other
		include Ressource

		attr_accessor :display_name, :ressources
		attr_reader :name


		def initialize(params)
			params.each do |k, v|
				self.send("#{k}=".to_sym, v)
			end
			# clone real name to display name and downcase show name (identifier)
			# for more reliable comparability
			self.display_name = self.name.clone
			self.name = self.name.downcase
			self
		end

		def cmp_by_hash(hash)
			self.name == hash[:name]
		end
		
		private
		attr_writer :name
	end
end
