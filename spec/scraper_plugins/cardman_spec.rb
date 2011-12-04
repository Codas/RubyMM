require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Scraper::CardmanThread do
	before do
		@other_url = <<EOF
[url]http://tehparadox.com/forum/f73/national-geographic-engineering-connections-hong-kongs-ocean-airport-720p-hdtv-x264-n-3487098/[/url]<br>
EOF
		@app_url = <<EOF
[url]http://tehparadox.com/forum/f51/acronis-true-image-home-2012-plus-pack-iso-rg-3450796/[/url]
EOF
		@game_url = <<EOF
[url]http://tehparadox.com/forum/f43/lego-harry-potter-years-5-7-reloaded-3499611/[/url]<br>
EOF
		@movie_url = <<EOF
[url]http://tehparadox.com/forum/f89/cowboys-aliens-2011-extended-bluray-remux-1080p-avc-dts-hd-ma-5-1-a-3490600/[/url]<br>
EOF
		@tv_show_url = <<EOF
[url]http://tehparadox.com/forum/f73/supernatural-s06e14-720p-hdtv-x264-immerse-1838135[/url]
EOF
	end

	context "sample cardman file" do
		before do
			cardman_file = 'spec/remote_data/cardman.html'
			@data = File.open(cardman_file, 'rb') { |file| file.read }
			@scraper_with_sample = Scraper::CardmanThread.new @data
		end

		it "finds 5 unique games" do
			@scraper_with_sample.games.size.should == 5
		end

		it "finds 1 unique Application" do
			@scraper_with_sample.applications.size.should == 1
		end
		
		it "finds 8 unique TV Show Episodes" do
			@scraper_with_sample.tv_shows.map{|e|e.episodes }.flatten.size.should == 8
		end

		it "finds 7 unique TV Shows" do
			@scraper_with_sample.tv_shows.size.should == 7
		end
		
		it "finds 4 unique other entries" do
			@scraper_with_sample.others.size.should == 5
		end
		
		it "finds 8 unique movies" do
			@scraper_with_sample.movies.size.should == 8
		end
	end

	describe "extracting metadata from url" do
		it "discards invalid URLs" do
			urls = <<EOF
					[url]http://tehparadox.com/forum/f43/stroke-fate-operation-valkyrie-skidrow-3487469/[url]<br>
					[url]http://tehparadox.com/forum/f51/acronis-true-image-home-2012-plus-pack-iso-rg/[/url]
					[url]http://tehparadox.com/forum/f73/supernatural-proper-720p-hdtv-x264-2hd-3448449/[/url]
					[url]http://tehparadox.com/forum/f90/colombiana-2011-720p-bluray-x264-thewretched-3495594/[/url]<br>
EOF
			scraper = Scraper::CardmanThread.new urls
			scraper.tv_shows.size.should == 0
			scraper.others.size.should == 1
			scraper.movies.size.should == 0
			scraper.applications.size.should == 0
			scraper.games.size.should == 0
		end

		it "fetches TVShot metadata" do
			scraper = Scraper::CardmanThread.new @tv_show_url
			show = scraper.tv_shows.first
			ep = scraper.tv_shows.first.episodes.first
			res = ep.ressources.first

			show.name.should =~ /^supernatural$/i
			ep.ressources.size.should == 1
			res[:source].should =~ /hdtv/i
			res[:resolution].should =~ /720p/
			res[:url].should =~ /1838135/
		end

		it "fetches Movie metadata" do
			scraper = Scraper::CardmanThread.new @movie_url
			movie = scraper.movies.first
			res = movie.ressources.first

			scraper.movies.size.should == 1
			movie.name.should =~ /Cowboys Aliens/i
			movie.year.should == 2011
			movie.ressources.size.should == 1
			res[:resolution].should == "1080p"
			res[:source].should == "bluray"
			res[:url].should =~ /3490600/
		end

		it "fetches Game metadata" do
			scraper = Scraper::CardmanThread.new @game_url
			game = scraper.games.first

			scraper.games.size.should == 1
			game.name.should =~ /lego harry potter years 5 7/i
			game.ressources.size.should == 1
			game.ressources.first[:release_group].should =~ /reloaded/
			game.ressources.first[:url].should =~ /3499611/
		end

		it "fetches Application metadata" do 
			scraper = Scraper::CardmanThread.new @app_url
			app = scraper.applications.first

			scraper.applications.size.should == 1
			app.name.should =~ /Acronis True Image home 2012/i
			app.ressources.size.should == 1
			app.ressources.first[:url].should =~ /3450796/
		end

		it "fetches Other metadata" do
			scraper = Scraper::CardmanThread.new @other_url
			other = scraper.others.first

			scraper.others.size.should == 1
			other.name.should =~ /National Geographic Engineering connections hong kongs ocean airport/i
			other.ressources.size.should == 1
			other.ressources.first[:url].should =~ /3487098/
		end
	end
end
