require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

class TestCaseLinkGrabber < Scraper::LinkGrabber 
end

class TestCaseMediaScraper < Scraper::MediaScraper
end

class TestCaseMediaGenerator < Scraper::MediaGenerator 
end

describe "Basic registration functionality" do
	it "should register LinkGrabber to the scraper list" do
		Scraper.link_grabbers.include?(TestCaseLinkGrabber).should be_true
	end

	it "should register MediaScraper to the scraper list" do
		Scraper.media_scrapers.include?(TestCaseMediaScraper).should be_true
	end

	it "should register MediaGenerator to the scraper list" do
		Scraper.media_generators.include?(TestCaseMediaGenerator).should be_true
	end
end
