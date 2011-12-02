require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Scraper::CardmanThread do
	before do
		cardman_file = 'spec/remote_data/cardman.html'
		@data = File.open(cardman_file, 'rb') { |file| file.read }
		@scraper_with_sample = Scraper::CardmanThread.new @data
	end

	context "sample cardman file" do

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
		
		it "should find 9 unique movies" do
			@scraper_with_sample.movies.size.should == 9
		end
	end
end
