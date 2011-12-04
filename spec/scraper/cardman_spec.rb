require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Scraper::CardmanThread do
	context "sample cardman file" do
		before do
			cardman_file = 'spec/remote_data/cardman.html'
			@data = File.open(cardman_file, 'rb') { |file| file.read }
			@scraper_with_sample = Scraper::CardmanThread.new @data
		end

		it "should find 5 unique games" do
			@scraper_with_sample.games.size.should == 5
		end

		it "should find 1 unique Application" do
			@scraper_with_sample.applications.size.should == 1
		end
		
		it "should find 9 unique TV Show Episodes" do
			@scraper_with_sample.episodes.size.should == 9
		end

		it "should find 7 unique TV Shows" do
			@scraper_with_sample.tv_shows.size.should == 7
		end
		
		it "should find 4 unique other entries" do
			@scraper_with_sample.others.size.should == 5
		end
		
		it "should find 8 unique movies" do
			@scraper_with_sample.movies.size.should == 8
		end
	end

	describe "extracting metadata from url" do
		it "should correctly discard invalid URLs" do
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

		it "should correctly fetch tv_show metadata" do
			url = <<EOF
[url]http://tehparadox.com/forum/f73/supernatural-s06e14-720p-hdtv-x264-immerse-1838135[/url]
EOF
			scraper = Scraper::CardmanThread.new url
			show = scraper.tv_shows.first
			ep = scraper.episodes.first

			show.name.should =~ /^supernatural$/i
			ep.ressources.size.should == 1
			ressource = ep.ressources.first
			ressource[:url].should =~ /1838135/
		end

		it "should correctly fetch movie metadata" do
			url = <<EOF
[url]http://tehparadox.com/forum/f89/cowboys-aliens-2011-extended-bluray-remux-1080p-avc-dts-hd-ma-5-1-a-3490600/[/url]<br>
EOF
			scraper = Scraper::CardmanThread.new url
			movie = scraper.movies.first

			scraper.movies.size.should == 1
			movie.name.should =~ /Cowboys Aliens/i
			movie.year.should == 2011
			movie.ressources.size.should == 1
			movie.ressources.first[:url].should =~ /3490600/
		end
	end
end
