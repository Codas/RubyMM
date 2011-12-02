require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Scraper do
	before do
		@matching_link_grabber = double(grabber_for?: true)
		@failing_link_grabber = double(grabber_for?: false)

		@matching_media_scraper = double(scraper_for?: true)
		@failing_media_scraper = double(scraper_for?: false)

		@matching_media_generator = double(generator_for?: true)
		@failing_media_generator = double(generator_for?: false)
	end

	it "should allow registration of link_grabbers" do
		Scraper.unregister_all!
		Scraper.register_link_grabber @matching_link_grabber
		Scraper.register_link_grabber @failing_link_grabber

		Scraper.link_grabbers_for(nil).should == [@matching_link_grabber]
	end

	it "should allow registration of media_scraper" do
		Scraper.unregister_all!
		Scraper.register_media_scraper @matching_media_scraper
		Scraper.register_media_scraper @failing_media_scraper

		Scraper.media_scrapers_for(nil).should == [@matching_media_scraper]
	end

	it "should allow registration of media_generator" do
		Scraper.unregister_all!
		Scraper.register_media_generator @matching_media_generator
		Scraper.register_media_generator @failing_media_generator

		Scraper.media_generators_for(nil).should == [@matching_media_generator]
	end
	
end
