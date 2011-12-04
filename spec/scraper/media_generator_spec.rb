require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Scraper::MediaGenerator do
	before do
		$tv_show = [
			{
				:info => {
					:name => "TVShow name 1"
				},
				:ep => {
					:season  => 1,
					:episode => 1
				},
				:ressource => {
					:resolution => "720p",
					:source     => "web-dl",
					:url        => "Episode url 1"
				}
			}
		]

		$movie = [
			{
				:info => {
					:name => "Movie name 1",
					:year => 2010
				},
				:ressource => {
					:resolution => "1080p",
					:source     => "bluray",
					:url        => "Movie url 1"
				}
			}
		]

		$game = [
			{
				:info => {
					:name => "Game 1"
				},
				:ressource => {
					:release_group => "skidrow",
					:url           => "Game url 1"
				}
			}
		]

		$application = [
			{
				:info => {
					:name => "Application name 1"
				},
				:ressource => {
					:url => "Application url 1"
				}
			}
		]

		$other = [
			{
				:info => {
					:name => "Other name 1"
				},
				:ressource => {
					:url => "Other url 1"
				}
			}
		]

		class Scraper::MediaGeneratorMinImp < Scraper::MediaGenerator
			generates :tv_shows, :movies, :games, :applications, :others

			def tv_show_items(arg) $tv_show end
			def movie_items(arg) $movie end
			def game_items(arg) $game end
			def application_items(arg) $application end
			def other_items(arg) $other end
		end
	end

	context "passing valid parameters" do
		it "creates a new TVShow and Episode" do
			scraper = Scraper::MediaGeneratorMinImp.new $tv_show
			show = scraper.tv_shows.first
			ep = show.episodes.first
			res = ep.ressources.first

			scraper.tv_shows.size.should == 1
			show.name.should == $tv_show[0][:info][:name]
			show.name.should == $tv_show[0][:info][:name]
			show.episodes.size.should == 1
			ep.ressources.size.should == 1
			ep.season.should == $tv_show[0][:ep][:season].to_i
			ep.episode.should == $tv_show[0][:ep][:episode].to_i
			res.should == $tv_show[0][:ressource]
		end

		it "crates a new Movie" do
			scraper = Scraper::MediaGeneratorMinImp.new $game
			movie = scraper.movies.first
			res = movie.ressources.first

			scraper.movies.size.should == 1
			movie.name.should == $movie[0][:info][:name]
			movie.ressources.size.should == 1
			res.should == $movie[0][:ressource]
		end

		it "creates a new Game" do
			scraper = Scraper::MediaGeneratorMinImp.new $game
			game = scraper.games.first
			res = game.ressources.first

			scraper.games.size.should == 1
			game.name.should == $game[0][:info][:name]
			game.ressources.size.should == 1
			res.should == $game[0][:ressource]
		end

		it "creates a new Application" do
			scraper = Scraper::MediaGeneratorMinImp.new $application
			application = scraper.applications.first
			res = application.ressources.first

			scraper.applications.size.should == 1
			application.name.should == $application[0][:info][:name]
			application.ressources.size.should == 1
			res.should == $application[0][:ressource]
		end

		it "creates a new Other Object" do
			scraper = Scraper::MediaGeneratorMinImp.new $other
			other = scraper.others.first
			res = other.ressources.first

			scraper.others.size.should == 1
			other.name.should == $other[0][:info][:name]
			other.ressources.size.should == 1
			res.should == $other[0][:ressource]
		end
	end

	context "Adding the same object multiple times" do
		it "does not create duplicate TVShows" do
			scraper = Scraper::MediaGeneratorMinImp.new $tv_show.push $tv_show[0]
			show = scraper.tv_shows.first
			ep = show.episodes.first
			res = ep.ressources.first

			scraper.tv_shows.size.should == 1
			show.episodes.size.should == 1
			ep.ressources.size.should == 1
		end

		it "does not create duplicate Movies" do
			scraper = Scraper::MediaGeneratorMinImp.new $movie.push $movie[0]
			movie = scraper.movies.first

			scraper.movies.size.should == 1
			movie.ressources.size.should == 1
		end

		it "does not create duplicate Movies" do
			scraper = Scraper::MediaGeneratorMinImp.new $movie.push $movie[0]
			movie = scraper.movies.first

			scraper.movies.size.should == 1
			movie.ressources.size.should == 1
		end

		it "does not create duplicate Games" do
			scraper = Scraper::MediaGeneratorMinImp.new $game.push $game[0]
			game = scraper.games.first

			scraper.games.size.should == 1
			game.ressources.size.should == 1
		end

		it "does not create duplicate Applications" do
			scraper = Scraper::MediaGeneratorMinImp.new $application.push $application[0]
			application = scraper.applications.first

			scraper.applications.size.should == 1
			application.ressources.size.should == 1
		end

		it "does not create duplicate Others Objects" do
			scraper = Scraper::MediaGeneratorMinImp.new $other.push $other[0]
			other = scraper.others.first

			scraper.others.size.should == 1
			other.ressources.size.should == 1
		end
	end

	context "adding ressources" do
		it "adds a TVShow Ressource" do
			clone = Marshal.load(Marshal.dump($tv_show.first))
			clone[:ressource][:url] = "other episode url"
			$tv_show.push clone

			scraper = Scraper::MediaGeneratorMinImp.new $tv_show
			show = scraper.tv_shows.first
			ep = show.episodes.first

			scraper.tv_shows.size.should == 1
			show.episodes.size.should == 1
			ep.ressources.size.should == 2
		end
		
		it "adds a Movie Ressource" do
			clone = Marshal.load(Marshal.dump($movie.first))
			clone[:ressource][:url] = "other movie url"
			$movie.push clone

			scraper = Scraper::MediaGeneratorMinImp.new $movie
			movie = scraper.movies.first

			scraper.movies.size.should == 1
			movie.ressources.size.should == 2
		end
		
		it "adds a Game Ressource" do
			clone = Marshal.load(Marshal.dump($game.first))
			clone[:ressource][:url] = "other game url"
			$game.push clone

			scraper = Scraper::MediaGeneratorMinImp.new $game
			game = scraper.games.first

			scraper.games.size.should == 1
			game.ressources.size.should == 2
		end
		
		it "adds an application Application Ressource" do
			clone = Marshal.load(Marshal.dump($application.first))
			clone[:ressource][:url] = "other application url"
			$application.push clone

			puts $application

			scraper = Scraper::MediaGeneratorMinImp.new $application
			application = scraper.applications.first

			scraper.applications.size.should == 1
			application.ressources.size.should == 2
		end
		
		it "adds an Other Object Ressource" do
			clone = Marshal.load(Marshal.dump($other.first))
			clone[:ressource][:url] = "another url"
			$other.push clone

			scraper = Scraper::MediaGeneratorMinImp.new $other
			other = scraper.others.first

			scraper.others.size.should == 1
			other.ressources.size.should == 2
		end
	end
end
